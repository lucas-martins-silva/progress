/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0505RP 2.00.00.012 } /*** "010012" 08/11/2024 15:31:08  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i aq0505rp MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: aq0505rp.P
**
**       Data....: 04/04/2016.
**
**       Objetivo: Relat¢rio de NÆo conformidades da carga 
** 
******************************************************************************/
{utp/ut-glob.i}
{include/tt-edit.i}
{include/i-rpvar.i} 

/* ************************  TEMP-TABLES DEFINITIONS ********************** */    
{aqp/aq0505.i1}

/* ************************  DEFINITIONS ********************************* */
DEFINE VARIABLE h-utapi033 AS HANDLE NO-UNDO.

IF NOT VALID-HANDLE(h-utapi033) THEN
    RUN utp/utapi033.p PERSISTENT SET h-utapi033.
        
    
/* ************************  PARAMETERS DEFINITIONS ********************** */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.   

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

RUN pi-inicializar IN h-acomp (INPUT c-titulo-relat).

ASSIGN c-programa     = "aq0505":U
       c-versao       = "I.00":U
       c-revisao      = "001":U
       c-sistema      = RETURN-VALUE
       c-rodape       = "TOTVS - ":U + c-programa  +  " - V:":U + c-versao.
       c-rodape       = FILL("-", 132 - LENGTH(c-rodape)) + c-rodape.
       
FIND FIRST param-global NO-LOCK NO-ERROR.
IF AVAIL param-global THEN
    ASSIGN c-empresa  = param-global.grupo.  

FIND FIRST tt-param NO-ERROR.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
 
RUN pi-executar IN THIS-PROCEDURE.

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.



/******************************* PROCEDURES ***********************************/
PROCEDURE pi-executar:
/*------------------------------------------------------------------------------
  Purpose: 
------------------------------------------------------------------------------*/
  blk_naoConforme:
  FOR EACH naocfedade-carg
     WHERE naocfedade-carg.cdn-naocfedade >= tt-param.cod-nao-conform-ini /* NÆo Conformidade */
       AND naocfedade-carg.cdn-naocfedade <= tt-param.cod-nao-conform-fim
       AND naocfedade-carg.dat-trans      >= tt-param.dt-trans-ini        /* Data Transa‡Æo   */
       AND naocfedade-carg.dat-trans      <= tt-param.dt-trans-fim        
       AND naocfedade-carg.cod-estabel    >= tt-param.cod-estab-ini       /* Estabelecimento  */
       AND naocfedade-carg.cod-estabel    <= tt-param.cod-estab-fim     
       AND naocfedade-carg.num-carg       >= tt-param.num-carg-ini        /* Carga            */
       AND naocfedade-carg.num-carg       <= tt-param.num-carg-fim
       NO-LOCK:

    /* 1 Dif. Quantidade / 2 Qualidade / 3 NÆo coleta */
    IF NOT(naocfedade-carg.idi-tip-naocfedade = 1 AND tt-param.tg-dif-qtde)   AND 
       NOT(naocfedade-carg.idi-tip-naocfedade = 2 AND tt-param.tg-qualidade)  AND 
       NOT(naocfedade-carg.idi-tip-naocfedade = 3 AND tt-param.tg-nao-coleta) THEN
       NEXT blk_naoConforme.

    /* 1 Pendente / 2 Em an lise / 3 Resolvida */
    IF NOT(naocfedade-carg.cdn-sit = 1 AND tt-param.tg-pendente)   AND 
       NOT(naocfedade-carg.cdn-sit = 2 AND tt-param.tg-em-analise) AND 
       NOT(naocfedade-carg.cdn-sit = 3 AND tt-param.tg-resolvida)  THEN
       NEXT blk_naoConforme.

    RUN pi-extracao-dados-excel.

  END.

  RUN pi-gera-planilha IN THIS-PROCEDURE.
  
  RETURN "OK":U.

END PROCEDURE.



/******************************* PROCEDURES ***********************************/
PROCEDURE pi-gera-planilha:
/*------------------------------------------------------------------------------
  Purpose: 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE qh             AS HANDLE    NO-UNDO.
  DEFINE VARIABLE bh             AS HANDLE    NO-UNDO.   

  DEFINE VARIABLE i-coluna       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE i-colunas      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE c-format       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-data-type    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE c-valor-coluna AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-largura      AS CHARACTER NO-UNDO.

  ASSIGN i-colunas = EXTENT(c-titulo-coluna).

  CREATE BUFFER bh FOR TABLE "tt-nao-conform-carga":U.
  CREATE QUERY qh .
  qh:SET-BUFFERS(bh).

  {utp/ut-liter.i Gerando_planilha * }
  RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

  DO i-coluna = 1 TO i-colunas:    

    ASSIGN c-largura      = REPLACE(STRING(d-largura-coluna[i-coluna] * 5.6),",",".")
           c-valor-coluna = c-titulo-coluna[i-coluna].

    ASSIGN c-format    = STRING(bh:BUFFER-FIELD(c-campo[i-coluna]):FORMAT)
           c-data-type = bh:BUFFER-FIELD(c-campo[i-coluna]):DATA-TYPE.

    /* Formato character deve ser passado em branco para a planilha */
    IF bh:BUFFER-FIELD(c-campo[i-coluna]):DATA-TYPE = "character":U THEN 
        ASSIGN c-format = " ":U.

    /* cria colunas planilha */
    RUN piColumn IN h-utapi033 (INPUT i-coluna,
                                INPUT c-data-type,
                                INPUT c-valor-coluna,
                                INPUT c-format,
                                INPUT c-largura).
  END.

  qh:QUERY-PREPARE("FOR EACH tt-nao-conform-carga":U). 
  qh:FORWARD-ONLY.  
  qh:QUERY-OPEN(). 

  REPEAT:
    qh:GET-NEXT().
    IF qh:QUERY-OFF-END THEN LEAVE.

    RUN piNewLine IN h-utapi033.

    DO i-coluna = 1 TO i-colunas:
      RUN piLine IN h-utapi033(INPUT i-coluna, INPUT bh:BUFFER-FIELD(c-campo[i-coluna]):BUFFER-VALUE).
    END.
  END.

  RUN pi-imprime-parametros-planilha IN THIS-PROCEDURE.

  RUN piProcessa IN h-utapi033 (INPUT-OUTPUT tt-param.arquivo, INPUT "AQ0505":U, INPUT c-titulo-relat).

  IF VALID-HANDLE(h-utapi033) THEN 
    DELETE OBJECT h-utapi033.

  RETURN "OK":U.

END PROCEDURE.



PROCEDURE pi-imprime-parametros-planilha PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: imprimir parametros utilizados para geracao do relatorio.
------------------------------------------------------------------------------*/   
  DEFINE VARIABLE c-lbl-ate         AS CHARACTER        NO-UNDO.  
  DEFINE VARIABLE iParamColumnWidth AS INTEGER EXTENT 2 NO-UNDO.   

  {utp/ut-liter.i at‚ *}
  ASSIGN c-lbl-ate = RETURN-VALUE.   

  CREATE tt-param-planilha. 
  ASSIGN tt-param-planilha.descricao = c-label-param[1] /* SELE€ÇO */
         tt-param-planilha.valor     = ''.

  CREATE tt-param-planilha.               
  ASSIGN tt-param-planilha.descricao = c-label-param[2] /* NÆo Conformidade */
         tt-param-planilha.valor     = STRING(tt-param.cod-nao-conform-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.cod-nao-conform-fim).
         
  CREATE tt-param-planilha.               
  ASSIGN tt-param-planilha.descricao = c-label-param[3] /* Data Transa‡Æo */
         tt-param-planilha.valor     = STRING(tt-param.dt-trans-ini, "99/99/9999":U) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.dt-trans-fim, "99/99/9999":U).

  CREATE tt-param-planilha.               
  ASSIGN tt-param-planilha.descricao = c-label-param[4] /* Estabelecimento */
         tt-param-planilha.valor     = STRING(tt-param.cod-estab-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.cod-estab-fim).

  CREATE tt-param-planilha.               
  ASSIGN tt-param-planilha.descricao = c-label-param[5] /* Carga */
         tt-param-planilha.valor     = STRING(tt-param.num-carg-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.num-carg-fim).
 
  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = '':U
         tt-param-planilha.valor     = '':U.

  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[6] /* PAR¶METROS */
         tt-param-planilha.valor     = '':U.
         
 CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[13] /* Tipo Nao conformidade */
         tt-param-planilha.valor     = '':U.        

  {utp/ut-liter.i Sim/NÆo * }
  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[7] /* Dif. Qtde */
         tt-param-planilha.valor     = STRING(tt-param.tg-dif-qtde, RETURN-VALUE).

  {utp/ut-liter.i Sim/NÆo * }
  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[8] /* Qualidade */
         tt-param-planilha.valor     = STRING(tt-param.tg-qualidade, RETURN-VALUE).
         
  {utp/ut-liter.i Sim/NÆo * }
  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[9] /* NÆo Coleta */
         tt-param-planilha.valor     = STRING(tt-param.tg-nao-coleta, RETURN-VALUE).

  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = '':U
         tt-param-planilha.valor     = '':U.      
                
  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[14] /*Situacao Nao conformidade */
         tt-param-planilha.valor     = '':U.         
         
  {utp/ut-liter.i Sim/NÆo * }
  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[10] /* Pendente */
         tt-param-planilha.valor     = STRING(tt-param.tg-pendente, RETURN-VALUE).

  {utp/ut-liter.i Sim/NÆo * }
  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[11] /* Em Analise */
         tt-param-planilha.valor     = STRING(tt-param.tg-em-analise, RETURN-VALUE).

  {utp/ut-liter.i Sim/NÆo * }
  CREATE tt-param-planilha.
  ASSIGN tt-param-planilha.descricao = c-label-param[12] /* Cancelados */
         tt-param-planilha.valor     = STRING(tt-param.tg-resolvida, RETURN-VALUE).

  ASSIGN iParamColumnWidth[1] = 130
         iParamColumnWidth[2] = 200.

  RUN setParamColumnWidth IN h-utapi033 (INPUT iParamColumnWidth).
  RUN setTTParam          IN h-utapi033 (INPUT TABLE tt-param-planilha).

  RETURN "OK":U.

END PROCEDURE.



PROCEDURE pi-extracao-dados-excel:
/*------------------------------------------------------------------------------
  Purpose: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE vl-dif        AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE tot-penaliz   AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE analise-nc    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ds-rejeicao   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ds-nao-coleta AS CHARACTER NO-UNDO.

  ASSIGN vl-dif = 0.
  FOR FIRST carg-rural FIELDS(cod-placa qtd-coleta qtd-aferid it-codigo cod-rota cod-transp)
      WHERE carg-rural.num-carg = naocfedade-carg.num-carg NO-LOCK:

    ASSIGN vl-dif = carg-rural.qtd-coleta - carg-rural.qtd-aferid.

    FOR FIRST transporte FIELDS(nome) NO-LOCK
        WHERE transporte.cod-transp = carg-rural.cod-transp:
    END.

  END.

  FOR FIRST produt-carg FIELDS(cdn-motiv-nao-coleta) NO-LOCK
      WHERE produt-carg.cdn-identif = naocfedade-carg.cdn-identif:

    ASSIGN ds-nao-coleta = "".  
    FOR FIRST motiv-nao-coleta FIELDS(des-motivo) NO-LOCK
        WHERE motiv-nao-coleta.cdn-motiv-nao-coleta = produt-carg.cdn-motiv-nao-coleta:
        ASSIGN ds-nao-coleta = motiv-nao-coleta.des-motivo.
    END.

  END.
  
  ASSIGN ds-rejeicao = "".
  FOR FIRST liber-carg FIELDS(codigo-rejei) NO-LOCK
      WHERE liber-carg.num-carg    = naocfedade-carg.num-carg    
        AND liber-carg.cdn-compart = naocfedade-carg.cdn-compart:

      FOR FIRST cod-rejeicao FIELDS(descricao)
          WHERE cod-rejeicao.codigo-rejei = liber-carg.codigo-rejei:
         ASSIGN ds-rejeicao = cod-rejeicao.descricao.
      END.

  END.

  ASSIGN analise-nc = "".
  FOR FIRST histor-naocfedade FIELDS (idi-tip-histo)
      WHERE histor-naocfedade.cdn-naocfedade = naocfedade-carg.cdn-naocfedade
        AND(histor-naocfedade.idi-tip-histo = 2  /* Penaliza     */
         OR histor-naocfedade.idi-tip-histo = 3) /* NÆo Penaliza */:
    IF histor-naocfedade.idi-tip-histo = 2 THEN
      ASSIGN analise-nc = {ininc/i01in01010.i 4 histor-naocfedade.idi-tip-histo}.
    ELSE 
      ASSIGN analise-nc = {ininc/i01in01010.i 4 histor-naocfedade.idi-tip-histo}.
  END.

  IF analise-nc = "" THEN DO:
    {utp/ut-liter.i Pendente * }
    ASSIGN analise-nc = RETURN-VALUE.
  END.

  ASSIGN tot-penaliz = 0.
  FOR EACH dest-cust-naocfedade FIELDS(val-dest)
     WHERE dest-cust-naocfedade.cdn-naocfedade = naocfedade-carg.cdn-naocfedade.
    ASSIGN tot-penaliz = tot-penaliz + dest-cust-naocfedade.val-dest.
  END.

  CREATE tt-nao-conform-carga.
  ASSIGN tt-nao-conform-carga.cod-estabel    = naocfedade-carg.cod-estabel
         tt-nao-conform-carga.nc-carga       = naocfedade-carg.cdn-naocfedade
         tt-nao-conform-carga.dt-trans       = naocfedade-carg.dat-trans
         tt-nao-conform-carga.situacao       = {ininc/i02in01009.i 4 naocfedade-carg.cdn-sit} /* 1 Pendente / 2 Em an lise / 3 Resolvida */
         tt-nao-conform-carga.carga          = naocfedade-carg.num-carg
         tt-nao-conform-carga.tipo-nc        = {ininc/i01in01009.i 4 naocfedade-carg.idi-tip-naocfedade}  /* 1 Dif. Quantidade / 2 Qualidade / 3 NÆo coleta */ 
         tt-nao-conform-carga.cdn-compart    = naocfedade-carg.cdn-compart
         tt-nao-conform-carga.pto-coleta     = naocfedade-carg.cod-pto-coleta
         tt-nao-conform-carga.placa          = IF AVAIL carg-rural  THEN carg-rural.cod-placa   ELSE ""
         tt-nao-conform-carga.qtde-coletada  = IF AVAIL carg-rural  THEN carg-rural.qtd-coleta  ELSE 0
         tt-nao-conform-carga.qtde-nc        = naocfedade-carg.val-quant
         tt-nao-conform-carga.qtde-aferida   = IF AVAIL carg-rural  THEN carg-rural.qtd-aferid  ELSE 0
         tt-nao-conform-carga.item           = IF AVAIL carg-rural  THEN carg-rural.it-codigo   ELSE ""
         tt-nao-conform-carga.rota	         = IF AVAIL carg-rural  THEN carg-rural.cod-rota    ELSE ""
         tt-nao-conform-carga.cod-transp     = IF AVAIL carg-rural  THEN carg-rural.cod-transp  ELSE 0
         tt-nao-conform-carga.nm-transport   = IF AVAIL transporte  THEN transporte.nome        ELSE ""
         tt-nao-conform-carga.nao-coleta     = IF AVAIL produt-carg THEN produt-carg.cdn-motiv-nao-coleta ELSE 0
         tt-nao-conform-carga.ds-nao-coleta  = ds-nao-coleta
   
         tt-nao-conform-carga.rejeicao       = IF AVAIL liber-carg THEN liber-carg.codigo-rejei ELSE 0
         tt-nao-conform-carga.ds-rejeicao    = ds-rejeicao
         tt-nao-conform-carga.analise-nc     = analise-nc   
         tt-nao-conform-carga.tot-penaliz    = tot-penaliz
         tt-nao-conform-carga.des-naocfedade = naocfedade-carg.des-naocfedade
         .

END PROCEDURE.
