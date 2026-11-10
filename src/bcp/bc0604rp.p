/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0604RP 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0604rp MBC}
&ENDIF


/*************************************************************************
**
**     Programa BC0604RP.P
**
**************************************************************************/

/* **************** Definicao de Variaveis do programa ***************** */ 
def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
def new global shared var v_cdn_empres_usuar   like empresa.ep-codigo no-undo.
def var c-lit-selecao       as char format "x(10)"   no-undo.
def var c-lit-impressao     as char format "x(15)"   no-undo.
def var c-lit-param         as char format "x(20)"   no-undo.
def var c-destino           as char format "x(10)"   no-undo.
def var h-acomp             as handle                no-undo.
DEF VAR v-ind-leitura-campo AS CHAR FORMAT "x(30)"   NO-UNDO.
DEF VAR v-ind-ocorrencia    AS CHAR FORMAT "x(10)"   NO-UNDO.
DEF VAR v-id-inicial        AS CHAR FORMAT "x(20)"   NO-UNDO.
DEF VAR v-id-final          AS CHAR FORMAT "x(20)"   NO-UNDO.
DEF VAR v-tipo-item         AS CHAR FORMAT "x(10)"   NO-UNDO.
DEF VAR v-log-tr-dec        AS LOG                   NO-UNDO.
DEF VAR c-editor            AS CHAR FORMAT "x(2000)" NO-UNDO.
DEF VAR c-etiqueta          AS CHAR FORMAT "x(10)"   NO-UNDO.
DEF VAR c-descricao         AS CHAR FORMAT "x(10)"   NO-UNDO.
DEF VAR c-etiq-selec        AS CHAR                  NO-UNDO.
DEF VAR v-num-cont          AS INT                   NO-UNDO.
DEF VAR c-processo          AS CHAR                  NO-UNDO.
DEF VAR c-ind-geracao       AS CHAR                  NO-UNDO.
DEF VAR c-nome-emit         AS CHAR                  NO-UNDO.
DEF VAR v-titulo            AS CHAR FORMAT "x(20)"   NO-UNDO.
DEF VAR c-embalagem         AS CHAR FORMAT "x(15)"   NO-UNDO.
DEF VAR c-ativo             AS CHAR FORMAT "x(10)"   NO-UNDO.
DEF VAR c-valor-campo       AS CHAR FORMAT "x(29)"   NO-UNDO.
DEF VAR c-valor-inicial     AS CHAR FORMAT "x(20)"   NO-UNDO.
DEF VAR c-valor-final       AS CHAR FORMAT "x(20)"   NO-UNDO.

/* ************** Definicao de preprocessadores de tabela ************** */ 
{cdp/cdcfgint.i}
&if "{&mgadm_version}" >= "2.05" &then
    &glob SeparadorLinhas Separador-Linhas /* bc-layout */
    &glob IndicadorIni    indicador-ini    /* bc-layout-registro */
    &glob IndicadorFim    indicador-Fim    /* bc-layout-registro */
    &glob Descricao       descricao        /* bc-layout-registro-item */
&else
    &glob SeparadorLinhas cod-aux[1]
    &glob IndicadorIni    char-1
    &glob IndicadorFim    char-2
    &glob Descricao       char-1
&endif

/* ********************* Definicao das temp-tables ********************* */ 
define temp-table tt-raw-digita NO-UNDO
    field raw-digita    as raw.

{bcp/bc0604.i}   
{include/tt-edit.i}

/* **** Definicoes das procedures para integracao com o Magnus i.00 **** */ 
{bcp/bcproxy.i2} 

/* ********************** Definicoes de parametros ********************* */ 
def input param r-raw as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer r-raw to tt-param.

/* ****************** Definicoes de forms do relatorio ***************** */ 
form
    bc-layout.cod-layout         COLON 25 " - " 
    bc-layout.descricao          NO-LABEL SKIP
    bc-layout.log-datasul        COLON 25 SKIP 
    bc-layout.num-versao         COLON 25 SKIP
    bc-tipo-layout.descricao     COLON 25 SKIP 
    v-ind-leitura-campo          COLON 25 SKIP
    bc-layout.{&SeparadorLinhas} COLON 25 SKIP
    bc-layout.separador-campos   COLON 25 SKIP
    with side-labels stream-io width 132 frame f-bc-layout.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-bc-layout:HANDLE).


form 
    bc-layout-registro.sequencia       FORMAT   ">>9" AT 01
    bc-tipo-layout-registro.descricao  FORMAT "x(40)" AT 11
    v-ind-ocorrencia                   FORMAT "x(10)" AT 52 
    c-valor-inicial                    FORMAT "x(20)" AT 70
    c-valor-final                      FORMAT "X(20)" AT 91
    with stream-io width 132 frame f-bc-layout-registro.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-bc-layout-registro:HANDLE).


form
    bc-layout-registro-item.sequencia     FORMAT   ">>9" AT  03 COLUMN-LABEL "Seq"
    v-tipo-item                           FORMAT "x(10)" AT  07
    bc-layout-registro-item.valor-item    FORMAT "x(30)" AT  19
    bc-layout-registro-item.tipo-dado     FORMAT "x(12)" AT  50
    c-valor-campo                         FORMAT "x(29)" AT  63
    bc-layout-registro-item.formato       FORMAT "x(25)" AT  93
    v-log-tr-dec                                         AT 119 COLUMN-LABEL "Dec"
    bc-layout-registro-item.num-decimais  FORMAT ">9"    AT 123
    with stream-io width 132 frame f-bc-layout-registro-item.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-bc-layout-registro-item:HANDLE).


form
 	tt-editor.conteudo format "x(80)" AT 05
    with stream-io width 132 frame f-imp.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-imp:HANDLE).


form
    bc-emitente-etiqueta.nome-abrev FORMAT "x(12)" AT  09
    c-nome-emit                     FORMAT "x(30)" AT  22
    c-processo                      FORMAT "x(20)" AT  53
    c-ind-geracao                   FORMAT "x(20)" AT  74
    bc-emitente-etiqueta.tipo-etiq  FORMAT ">>>9"  AT  95
    v-titulo                        FORMAT "x(30)" AT 100
    with stream-io width 132 frame f-bc-emitente-etiqueta.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-bc-emitente-etiqueta:HANDLE).

    
form
    skip(2)
    c-lit-selecao         NO-LABEL       COLON 30 SKIP(1)
    tt-param.iIniLayout   format ">>>9"  COLON 30 
    "|< >|"                              AT    36 
    tt-param.iEndLayout   format ">>>9"  NO-LABEL SKIP
    tt-param.lIniDatasul                 COLON 30 
    "|< >|"                              AT    36   
    tt-param.lEndDatasul                 NO-LABEL SKIP 
    tt-param.iIniVersao   format ">>>9"  COLON 30 
    "|< >|"                              AT    36
    tt-param.iEndVersao   format ">>>9"  NO-LABEL SKIP(1) 
    c-lit-param           NO-LABEL       COLON 30 SKIP(1)
    tt-param.lImprDescr                  COLON 50 SKIP
    tt-param.lImprEtiq                   COLON 50 SKIP
    tt-param.lImprEmit                   COLON 50 SKIP(1)
    c-lit-impressao       NO-LABEL       COLON 30 SKIP(1)
    c-destino                            COLON 30 "-"
    tt-param.arquivo      FORMAT "x(30)" NO-LABEL
    with side-label stream-io width 132 frame f-param.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param:HANDLE).


/* **************** Definicoes de literais para as forms *************** */ 
{utp/ut-liter.i Sele‡Æo * R}
assign c-lit-selecao = trim(return-value) + ":".

{utp/ut-liter.i Layout * R}
ASSIGN tt-param.iIniLayout:LABEL IN FRAME f-param = TRIM(RETURN-VALUE). 

{utp/ut-liter.i PadrÆo_Datasul * R}
ASSIGN tt-param.lIniDatasul:LABEL IN FRAME f-param = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Sim/NÆo" * R}
ASSIGN tt-param.lIniDatasul:FORMAT IN FRAME f-param = TRIM(RETURN-VALUE)
       tt-param.lEndDatasul:FORMAT IN FRAME f-param = TRIM(RETURN-VALUE)
       tt-param.lImprDescr :FORMAT IN FRAME f-param = TRIM(RETURN-VALUE)
       tt-param.lImprEtiq  :FORMAT IN FRAME f-param = TRIM(RETURN-VALUE)
       tt-param.lImprEmit  :FORMAT IN FRAME f-param = TRIM(RETURN-VALUE)
       v-log-tr-dec        :FORMAT IN FRAME f-bc-layout-registro-item = TRIM(RETURN-VALUE). 

{utp/ut-liter.i VersÆo * R}
ASSIGN tt-param.iIniVersao:LABEL IN FRAME f-param = TRIM(RETURN-VALUE). 

{utp/ut-liter.i Parƒmetros * R}
assign c-lit-param = trim(return-value) + ":".

{utp/ut-liter.i Imprime_Descri‡Æo_Campos * R}
ASSIGN tt-param.lImprDescr:LABEL IN FRAME f-param = TRIM(RETURN-VALUE). 

{utp/ut-liter.i Imprime_Etiquetas_Relacionadas * R}
ASSIGN tt-param.lImprEtiq:LABEL IN FRAME f-param = TRIM(RETURN-VALUE). 

{utp/ut-liter.i Imprime_Relacionamentos_Emitente * R}
ASSIGN tt-param.lImprEmit:LABEL IN FRAME f-param = TRIM(RETURN-VALUE). 

{utp/ut-liter.i ImpressÆo * R}
assign c-lit-impressao = trim(return-value) + ":".

{utp/ut-liter.i Destino * R}
assign c-destino:label in frame f-param = trim(return-value).

{utp/ut-liter.i Tipo_Layout * R} 
ASSIGN bc-tipo-layout.descricao:LABEL IN FRAME f-bc-layout = TRIM(RETURN-VALUE).

{utp/ut-liter.i Tipo_Tratamento * R}
ASSIGN v-ind-leitura-campo:LABEL IN FRAME f-bc-layout= TRIM(RETURN-VALUE).

{utp/ut-liter.i Separador_Linha * R}
ASSIGN bc-layout.{&SeparadorLinhas}:LABEL IN FRAME f-bc-layout = TRIM(RETURN-VALUE).

{utp/ut-liter.i Separador_Campo * R}
ASSIGN bc-layout.separador-campos:LABEL IN FRAME f-bc-layout = TRIM(RETURN-VALUE).

{utp/ut-liter.i Ocorrˆncia * R}
ASSIGN v-ind-ocorrencia:LABEL IN FRAME f-bc-layout-registro = TRIM(RETURN-VALUE).

{utp/ut-liter.i Id_Inicial: * R}
ASSIGN v-id-inicial = TRIM(RETURN-VALUE).

{utp/ut-liter.i Id_Inicial * R}
ASSIGN c-valor-inicial:LABEL IN FRAME f-bc-layout-registro = TRIM(RETURN-VALUE).

{utp/ut-liter.i Id_Final: * R}
ASSIGN v-id-final = TRIM(RETURN-VALUE).

{utp/ut-liter.i Id_Final * R}
ASSIGN c-valor-final:LABEL IN FRAME f-bc-layout-registro = TRIM(RETURN-VALUE).

{utp/ut-liter.i Tp_Campo * R}
ASSIGN v-tipo-item:LABEL IN FRAME f-bc-layout-registro-item = TRIM(RETURN-VALUE).

{utp/ut-liter.i Nome * R}
ASSIGN bc-layout-registro-item.valor-item:LABEL IN FRAME f-bc-layout-registro-item = TRIM(RETURN-VALUE).

{utp/ut-liter.i Valor * R}
ASSIGN c-valor-campo:LABEL IN FRAME f-bc-layout-registro-item = TRIM(RETURN-VALUE).

{utp/ut-liter.i Seq * R}
ASSIGN bc-layout-registro-item.sequencia:LABEL IN FRAME f-bc-layout-registro-item = TRIM(RETURN-VALUE).

{utp/ut-liter.i Num_Dec * R}
ASSIGN bc-layout-registro-item.num-decimais:LABEL IN FRAME f-bc-layout-registro-item = TRIM(RETURN-VALUE).
                    
{utp/ut-liter.i "Dec" * R}
ASSIGN v-log-tr-dec:LABEL IN FRAME f-bc-layout-registro-item = TRIM(RETURN-VALUE).

{utp/ut-liter.i Descri‡Æo * R}
ASSIGN tt-editor.conteudo:LABEL IN FRAME f-imp = TRIM(RETURN-VALUE)
       c-descricao = TRIM(RETURN-VALUE).

{utp/ut-liter.i Etiqueta * R}
ASSIGN c-etiqueta = TRIM(RETURN-VALUE).

{utp/ut-liter.i Processo * R}
ASSIGN c-processo:LABEL IN FRAME f-bc-emitente-etiqueta = TRIM(RETURN-VALUE).

{utp/ut-liter.i Gera‡Æo * R}
ASSIGN c-ind-geracao:LABEL IN FRAME f-bc-emitente-etiqueta = TRIM(RETURN-VALUE).

{utp/ut-liter.i Nome_Emitente * R}
ASSIGN c-nome-emit:LABEL IN FRAME f-bc-emitente-etiqueta = TRIM(RETURN-VALUE).

{utp/ut-liter.i Tipo_Etiqueta * R}
ASSIGN v-titulo:LABEL IN FRAME f-bc-emitente-etiqueta = TRIM(RETURN-VALUE).

{utp/ut-liter.i Embalagem * R}
ASSIGN c-embalagem = TRIM(RETURN-VALUE).

{utp/ut-liter.i Ativo * R}
ASSIGN c-ativo = TRIM(RETURN-VALUE).

/* ************************* Inicio do Programa ************************ */ 
{include/i-rpvar.i}
{include/pi-edit.i}

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

{utp/ut-liter.i "Relat¢rio de Layouts de Etiqueta" * L}
assign c-titulo-relat = trim(return-value).
 
{utp/ut-liter.i "Coleta de Dados" * C}
assign c-sistema  = trim(return-value).

{include/i-rpcab.i}
{include/i-rpout.i}

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i "Layouts de Etiqueta" * L}
run pi-inicializar in h-acomp (trim(return-value)).

view frame f-cabec.
view frame f-rodape.

FOR EACH bc-layout NO-LOCK
   WHERE bc-layout.cod-layout  >= tt-param.iIniLayout
   AND   bc-layout.cod-layout  <= tt-param.iEndLayout
   AND   bc-layout.log-datasul >= tt-param.lIniDatasul
   AND   bc-layout.log-datasul <= tt-param.lEndDatasul
   AND   bc-layout.num-versao  >= tt-param.iIniVersao
   AND   bc-layout.num-versao  <= tt-param.iEndVersao:
   
   /* Inicio -- Projeto Internacional */
   {utp/ut-liter.i "Layout" *}
   RUN pi-acompanhar IN h-acomp (RETURN-VALUE + ": " + STRING(bc-layout.cod-layout)).
   
   FIND bc-tipo-layout NO-LOCK
      WHERE bc-tipo-layout.cod-tipo-layout = bc-layout.cod-tipo-layout NO-ERROR.

   ASSIGN v-ind-leitura-campo = {clinc/i01cl023.i 04 bc-layout.ind-leitura-campo}.
   
   /* Impressao do Layout */
   DISP bc-layout.cod-layout
        bc-layout.descricao
        bc-layout.log-datasul
        bc-layout.num-versao
        bc-tipo-layout.descricao
        v-ind-leitura-campo 
        bc-layout.{&SeparadorLinhas}
        bc-layout.separador-campos WITH FRAME f-bc-layout.
   DOWN WITH FRAME f-bc-layout.

   /* Verificacao dos registros do layout */     
   FOR EACH bc-layout-registro NO-LOCK
      WHERE bc-layout-registro.cod-layout  = bc-layout.cod-layout
      AND   bc-layout-registro.log-datasul = bc-layout.log-datasul
      AND   bc-layout-registro.num-versao  = bc-layout.num-versao:
      
      FIND bc-tipo-layout-registro NO-LOCK
         WHERE bc-tipo-layout-registro.cod-tipo-layout          = bc-layout.cod-tipo-layout
         AND   bc-tipo-layout-registro.cod-tipo-layout-registro = bc-layout-registro.cod-tipo-layout-registro NO-ERROR.

      ASSIGN v-ind-ocorrencia = {clinc/i01cl024.i 04 bc-layout-registro.ind-ocorrencia}.
      &if "{&mgadm_version}" >= "2.05" &then  
            ASSIGN c-valor-inicial = bc-layout-registro.indicador-ini 
                   c-valor-final   = bc-layout-registro.indicador-Fim.  
      &else
            ASSIGN c-valor-inicial = bc-layout-registro.char-1
                   c-valor-final = bc-layout-registro.char-2.
            
      &endif
      /* Impressao dos registros do Layout */
      DISP bc-layout-registro.sequencia
           bc-tipo-layout-registro.descricao WHEN AVAIL bc-tipo-layout-registro
           v-ind-ocorrencia 
           c-valor-inicial 
           c-valor-final WITH FRAME f-bc-layout-registro.
      DOWN WITH FRAME f-bc-layout-registro.
      
      /* Verifica se imprime Descricao do registro do layout */
      IF tt-param.lImprDescr THEN DO:
          ASSIGN c-editor = &if "{&mgadm_version}" >= "2.05" &then
                            bc-layout-registro.definicao-funcao
                            &else
                            bc-layout-registro.cod-aux[1]
                          + bc-layout-registro.cod-aux[2]
                          + bc-layout-registro.cod-aux[3]
                          + bc-layout-registro.cod-aux[4]
                            &endif.
      
          IF c-editor <> "":U THEN DO:
              RUN pi-print-editor (c-editor, 80).

              FIND FIRST tt-editor NO-ERROR.
              DISP tt-editor.conteudo WHEN AVAIL tt-editor WITH frame f-imp.
              DOWN WITH FRAME f-imp.
              FOR EACH tt-editor WHERE tt-editor.linha > 1:
             	  	PUT tt-editor.conteudo AT 03.
              END.
          END.
      END.
      
      /* Verificao dos itens do registro do layout */
      FOR EACH bc-layout-registro-item NO-LOCK
         WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro:
        
         ASSIGN v-tipo-item  = {clinc/i01cl025.i 04 bc-layout-registro-item.tipo-item}
                v-log-tr-dec = (bc-layout-registro-item.tipo-dado = "DECIMAL":U 
                                AND bc-layout-registro-item.num-decimais <> 0).
         &if "{&mgadm_version}" >= "2.05" &then
            assign c-valor-campo = bc-layout-registro-item.valor-campo.
         &else                     
            assign c-valor-campo =  bc-layout-registro-item.char-2.
         &endif
         /* impressao dos itens do registro do layout */
         DISP bc-layout-registro-item.sequencia
              v-tipo-item
              bc-layout-registro-item.valor-item
              bc-layout-registro-item.tipo-dado
              c-valor-campo
              bc-layout-registro-item.formato
              v-log-tr-dec                         WHEN bc-layout-registro-item.tipo-dado = "DECIMAL":U 
              bc-layout-registro-item.num-decimais WHEN v-log-tr-dec
              WITH FRAME f-bc-layout-registro-item.
         DOWN WITH FRAME f-bc-layout-registro-item.
         
         IF((bc-layout.ind-leitura-campo = 4 /* Identificadores */ 
         OR  bc-layout.ind-leitura-campo = 5 /* AIM Brasil */) 
         AND(bc-layout-registro-item.id-inicial <> "":U 
         OR  bc-layout-registro-item.id-final   <> "":U)) THEN DO:
             PUT v-id-inicial                                      AT 03 
                 bc-layout-registro-item.id-inicial FORMAT "x(20)" SPACE(1)
                 v-id-final                                        
                 bc-layout-registro-item.id-final   FORMAT "x(20)" SKIP.
         END.
         
         /* Verifica se imprime descricao dos itens do registro do layout */
         IF tt-param.lImprDescr THEN DO:
             ASSIGN c-editor = &if "{&mgadm_version}" >= "2.05" &then
                               bc-layout-registro-item.definicao-funcao
                               &else
                               bc-layout-registro-item.cod-aux[1]
                             + bc-layout-registro-item.cod-aux[2]
                             + bc-layout-registro-item.cod-aux[3]
                             + bc-layout-registro-item.cod-aux[4]
                               &endif.
          
             IF c-editor <> "":U THEN DO:
                 RUN pi-print-editor (c-editor, 80).
    
                 FIND FIRST tt-editor NO-ERROR.
                 DISP tt-editor.conteudo WHEN AVAIL tt-editor WITH frame f-imp.
                 DOWN WITH FRAME f-imp.
                 FOR EACH tt-editor WHERE tt-editor.linha > 1:
               	  	PUT tt-editor.conteudo AT 05.
                 END.
             END.
         END.         
      END. /* bc-layout-registro-item */
   END. /* bc-layout-registro */
      
   /* Verifica se imprime etiquetas relacionadas */
   IF tt-param.lImprEtiq THEN DO:
      PUT SKIP(1)
          c-etiqueta   AT 07 
          c-descricao  AT 18 SKIP
          FILL("-",10) AT 07 FORMAT "x(10)"
          FILL("-",40) AT 18 FORMAT "X(40)" SKIP. 
         
      ASSIGN c-etiq-selec = "".
      &if '{&mgcld_version}' >= '2.04' &then
         FOR EACH tipo-etiqueta NO-LOCK USE-INDEX ch-layout
      &else
         FOR EACH tipo-etiqueta NO-LOCK
      &endif
      &if '{&mgcld_version}' >= '2.04' &then
         WHERE tipo-etiqueta.cod-layout  = bc-layout.cod-layout
      &else    
         WHERE tipo-etiqueta.int-1  = bc-layout.cod-layout
      &endif
      &if '{&mgcld_version}' >= '2.04' &then
         AND   tipo-etiqueta.log-datasul = bc-layout.log-datasul
      &else
         AND   tipo-etiqueta.log-1 = bc-layout.log-datasul
      &endif
         BY tipo-etiqueta.tipo-etiq:
        
         PUT tipo-etiqueta.tipo-etiq AT 07
             tipo-etiqueta.titulo    AT 18 SKIP.   
            
         IF c-etiq-selec = "" THEN
             ASSIGN c-etiq-selec = string(tipo-etiqueta.tipo-etiq).
         ELSE 
             ASSIGN c-etiq-selec = c-etiq-selec + ',' + string(tipo-etiqueta.tipo-etiq).
      END.
     
      /* Verifica se imprime relacionamentos com emitentes */
      IF tt-param.lImprEmit THEN DO:
         DO v-num-cont = 1 TO NUM-ENTRIES(c-etiq-selec):
             FOR EACH bc-emitente-etiqueta NO-LOCK
                 WHERE bc-emitente-etiqueta.tipo-etiq = INT(ENTRY(v-num-cont,c-etiq-selec))
                 BY bc-emitente-etiqueta.nome-abrev:
                
                 ASSIGN c-processo    = {clinc/i01cl029.i 04 bc-emitente-etiqueta.processo}.
                 ASSIGN c-ind-geracao = {clinc/i02cl029.i 04 bc-emitente-etiqueta.ind-geracao}.
         
                 RUN pi-verifica-emitente (bc-emitente-etiqueta.nome-abrev,
                                           bc-emitente-etiqueta.nome-abrev,
                                           0,  /* Codigo do Emitente               */
                                           0,  /* Codigo do Emitente               */
                                           5,  /* Tipo de Acesso 0=Currente ....   */
                                           2). /* Record-Frase = 2 (nome abreviado)*/
                
                 ASSIGN  c-nome-emit = IF NOT AVAIL ttReturnMessages THEN 
                                          STRING(ttEmitente.Nome-Emit)
                                       ELSE "":U.
                                       
                 FIND tipo-etiqueta NO-LOCK  
                     WHERE tipo-etiqueta.tipo-etiq = bc-emitente-etiqueta.tipo-etiq NO-ERROR.
                 ASSIGN v-titulo = IF AVAIL tipo-etiqueta THEN tipo-etiqueta.titulo ELSE "":U.
                
                 /* imprime emitentes das etiquetas relacionadas */ 
                 DISP bc-emitente-etiqueta.nome-abrev 
                      c-nome-emit
                      c-processo
                      c-ind-geracao     
                      bc-emitente-etiqueta.tipo-etiq  
                      v-titulo
                      WITH FRAME f-bc-emitente-etiqueta.
                 DOWN WITH FRAME f-bc-emitente-etiqueta.
                 
                 /* Verifica impressao das embalagens */
                 FOR EACH bc-ext-embalagem NO-LOCK
                     WHERE bc-ext-embalagem.processo   = bc-emitente-etiqueta.processo
                     AND   bc-ext-embalagem.nome-abrev = bc-emitente-etiqueta.nome-abrev
                     BREAK BY bc-ext-embalagem.processo:
                     
                     IF FIRST(bc-ext-embalagem.processo) THEN DO:
                          PUT SKIP(1)
                              c-embalagem      AT 12 
                              c-etiqueta       AT 28 
                              c-descricao      AT 39
                              c-ativo          AT 90
                              FILL("-",18)     AT 12 FORMAT "x(15)"
                              FILL("-",10)     AT 28 FORMAT "x(10)"
                              FILL("-",50)     AT 39 FORMAT "x(50)"
                              FILL("-",08)     AT 90 FORMAT "X(08)" SKIP. 
                     END.

                     FIND tipo-etiqueta NO-LOCK  
                         WHERE tipo-etiqueta.tipo-etiq = bc-ext-embalagem.tipo-etiq NO-ERROR.
                        
                     /* impressao das embalagens */    
                     PUT bc-ext-embalagem.sigla-embalagem AT 12 FORMAT "!xx"
                         bc-ext-embalagem.tipo-etiq       AT 28 
                         tipo-etiqueta.titulo             AT 39 FORMAT "x(50)"
                         bc-ext-embalagem.log-ativo       AT 90 SKIP. 
                 END. /* bc-ext-embalagem */
             END. /* bc-emitente-etiqueta */
         END. /* do .. num-entries*/
      END. /* impressao emitentes */
   END. /* impressao etiquetas */
END. /* bc-layout */

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

PAGE.
DISP c-lit-selecao
     tt-param.iIniLayout
     tt-param.iEndLayout
     tt-param.lIniDatasul
     tt-param.lEndDatasul
     tt-param.iIniVersao
     tt-param.iEndVersao
     c-lit-param
     tt-param.lImprDescr
     tt-param.lImprEtiq
     tt-param.lImprEmit
     c-lit-impressao
     c-destino
     tt-param.arquivo with frame f-param.

{include/i-rpclo.i}

run pi-finalizar in h-acomp.
return "OK":U.
