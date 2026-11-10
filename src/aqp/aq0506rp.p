/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0506RP 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0506RP MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: AQ0506RP.P
**
**       Data....: 13/07/2016.
**
**       Objetivo: Relatorio de registros de altera‡äes das 
**                 informa‡äes do mapa de coleta.
**                 
** 
******************************************************************************/
{utp/ut-glob.i}
{include/tt-edit.i}
{include/i-rpvar.i} 

/* ************************  TEMP-TABLES DEFINITIONS ********************** */    
{aqp/aq0506.i1}

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

ASSIGN c-programa     = "AQ0506":U
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
  DEFINE VARIABLE label_         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE conteudo_      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE old_           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE produtor_      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE nomeProdutor_  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE nomePtoColeta_ AS CHARACTER NO-UNDO.

  EMPTY TEMP-TABLE tt-alter-carga.

  DEFINE VARIABLE c-lbl-add AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-lbl-del AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-lbl-upd AS CHARACTER NO-UNDO.

  {utp/ut-liter.i InclusÆo * }
  ASSIGN c-lbl-add = RETURN-VALUE.

  {utp/ut-liter.i Elimina‡Æo * }
  ASSIGN c-lbl-del = RETURN-VALUE.

  {utp/ut-liter.i Altera‡Æo * }
  ASSIGN c-lbl-upd = RETURN-VALUE.

  FOR EACH alter-produt-carg NO-LOCK
     WHERE alter-produt-carg.dat-alter >= tt-param.dt-alter-ini
       AND alter-produt-carg.dat-alter <= tt-param.dt-alter-fim
       AND alter-produt-carg.cod-usuar >= tt-param.cod-usuar-ini
       AND alter-produt-carg.cod-usuar <= tt-param.cod-usuar-fim
       AND alter-produt-carg.num-carg  >= tt-param.num-carg-ini
       AND alter-produt-carg.num-carg  <= tt-param.num-carg-fim,
      EACH carg-rural 
     FIELDS(num-carg cod-estabel dat-trans cod-rota)
     WHERE carg-rural.num-carg     = alter-produt-carg.num-carg
       AND carg-rural.cod-estabel >= tt-param.cod-estab-ini
       AND carg-rural.cod-estabel <= tt-param.cod-estab-fim
       AND carg-rural.dat-trans   >= tt-param.dt-trans-ini
       AND carg-rural.dat-trans   <= tt-param.dt-trans-fim NO-LOCK:

      ASSIGN label_         = ""
             conteudo_      = ""
             old_           = ""
             new_           = ""
             nomeProdutor_  = ""
             nomePtoColeta_ = "".

      /*** Se for ADD ou DEL nÆo exibir conte£do nesta coluna ***/
      IF alter-produt-carg.cod-campo <> "ADD":U    AND 
         alter-produt-carg.cod-campo <> "DELETE":U THEN DO:
		 
        &if "{&movind_dbtype}" <> "progress" &then 
          FOR FIRST shmovind._Field NO-LOCK
              WHERE _Field._Field-Name = alter-produt-carg.cod-campo:
                ASSIGN label_ = _Field._Label.
          END.
        &endif.
      
        &if "{&mgind_dbtype}" = "PROGRESS" &then 
          FOR FIRST movind._Field NO-LOCK
              WHERE _Field._Field-Name = alter-produt-carg.cod-campo:
                ASSIGN label_ = _Field._Label.
          END.    
        &endif. 

        ASSIGN conteudo_ = TRIM(REPLACE(REPLACE(REPLACE(alter-produt-carg.conteudo, "DE =>":U, "":U), "PARA =>":U, ";":U), " ":U, "":U)).
        ASSIGN old_ = ENTRY(1, conteudo_, ";":U )
               new_ = ENTRY(2, conteudo_, ";":U ).
      END.

      IF alter-produt-carg.cod-campo = "DELETE":U OR alter-produt-carg.cod-campo = "ADD":U  THEN DO:
        ASSIGN conteudo_ = TRIM(REPLACE(REPLACE(REPLACE(alter-produt-carg.conteudo, "Produtor =>":U, "":U), "QTD =>":U, ";":U), " ":U, "":U))
               produtor_ = INTEGER(ENTRY(1, conteudo_, ";":U )).
      END.

      FOR FIRST produt-carg NO-LOCK
          WHERE produt-carg.cdn-identif = alter-produt-carg.cdn-identif:
          
          ASSIGN produtor_ = produt-carg.cdn-produt-rural.
          
          FIND FIRST pto-coleta NO-LOCK
               WHERE pto-coleta.cod-pto-coleta = produt-carg.cod-pto-coleta NO-ERROR.
          IF AVAIL pto-coleta THEN
              ASSIGN nomePtoColeta_ = pto-coleta.des-pto-coleta.
      END.
      
      
      FIND FIRST emitente NO-LOCK
           WHERE emitente.cod-emitente = produtor_ NO-ERROR.
        IF AVAIL emitente THEN
          ASSIGN nomeProdutor_ = emitente.nome-emit.
          
      FIND FIRST rota-coleta NO-LOCK
           WHERE rota-coleta.cod-rota = carg-rural.cod-rota NO-ERROR.

      CREATE tt-alter-carga.
      ASSIGN tt-alter-carga.cod-estabel      = carg-rural.cod-estabel
             tt-alter-carga.rota             = carg-rural.cod-rota
             tt-alter-carga.des-rota         = rota-coleta.des-rota
             tt-alter-carga.dat-alter        = alter-produt-carg.dat-alter
             tt-alter-carga.hora-alter       = alter-produt-carg.hora-alter
             tt-alter-carga.cod-usuar        = alter-produt-carg.cod-usuar
             tt-alter-carga.motivo           = alter-produt-carg.des-motivo
             tt-alter-carga.num-carga        = alter-produt-carg.num-carg
             tt-alter-carga.des-pto-coleta   = nomePtoColeta_
             tt-alter-carga.nome-produtor    = nomeProdutor_
             tt-alter-carga.campo	         = label_
             tt-alter-carga.conteudo-ant     = old_
             tt-alter-carga.conteudo-novo    = new_
             tt-alter-carga.cdn-compart      = IF AVAIL produt-carg THEN produt-carg.cdn-compart
                                                                    ELSE 0
             tt-alter-carga.cod-pto-coleta   = IF AVAIL produt-carg THEN produt-carg.cod-pto-coleta
                                                                    ELSE ""
             tt-alter-carga.cdn-reposit      = IF AVAIL produt-carg THEN produt-carg.cdn-repos
                                                                    ELSE 0
             tt-alter-carga.cdn-produt-rural = produtor_
             tt-alter-carga.acao             = IF alter-produt-carg.cod-campo = "ADD":U THEN c-lbl-add     /*InclusÆo*/
                                                                                        ELSE
                                               IF alter-produt-carg.cod-campo = "DELETE":U THEN c-lbl-del  /*Elimina‡Æo*/
                                                                                           ELSE c-lbl-upd. /*Altera‡Æo */
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
  
  CREATE BUFFER bh FOR TABLE "tt-alter-carga":U.
  CREATE QUERY qh .
  qh:SET-BUFFERS(bh).

  {utp/ut-liter.i Gerando_planilha * }
  RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).
  
  DO i-coluna = 1 TO i-colunas:    
  
    ASSIGN c-largura      = REPLACE(STRING(d-largura-coluna[i-coluna] * 5.6),",",".")
           c-valor-coluna = c-titulo-coluna[i-coluna].

    ASSIGN c-format    = STRING(bh:BUFFER-FIELD(c-campo[i-coluna]):FORMAT)
           c-data-type = bh:BUFFER-FIELD(c-campo[i-coluna]):DATA-TYPE.

    /* formato data de ser passado para character devido a restricoes da api que gera planilha */
    IF c-data-type = "date":U THEN 
        ASSIGN c-format    = " ":U
               c-data-type = "character":U.

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

  qh:QUERY-PREPARE("FOR EACH tt-alter-carga":U). 
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

  RUN piProcessa IN h-utapi033 (INPUT-OUTPUT tt-param.arquivo, INPUT "AQ0506":U, INPUT c-titulo-relat).
  
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
           tt-param-planilha.valor     = "".

    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[2] /* Estab */
           tt-param-planilha.valor     = tt-param.cod-estab-ini + " ":U + c-lbl-ate + " ":U + tt-param.cod-estab-fim.

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[3] /* Carga */
           tt-param-planilha.valor     = STRING(tt-param.num-carg-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.num-carg-fim). 

    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[4] /* Data_Altera‡Æo */
           tt-param-planilha.valor     = STRING(tt-param.dt-alter-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.dt-alter-fim).
    
    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[5] /* Data_Trans */
           tt-param-planilha.valor     = STRING(tt-param.dt-trans-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.dt-trans-fim).

    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[6] /* Usu rio */
           tt-param-planilha.valor     = STRING(tt-param.cod-usuar-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.cod-usuar-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ""
           tt-param-planilha.valor     = "".

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[8] /* impressao */
           tt-param-planilha.valor     = "".

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[7] /* Arquivo_de_saida */
           tt-param-planilha.valor     = tt-param.arquivo.
           
           
    ASSIGN iParamColumnWidth[1] = 100
           iParamColumnWidth[2] = 200.

    RUN setParamColumnWidth IN h-utapi033 (INPUT iParamColumnWidth).
    RUN setTTParam          IN h-utapi033 (INPUT TABLE tt-param-planilha).
    
    RETURN "OK":U.
END PROCEDURE.
