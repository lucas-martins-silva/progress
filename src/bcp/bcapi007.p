/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI007 2.00.00.075 } /*** "010075" 23/01/2024 11:23:10 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi007 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1998)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*************************************************************************
**
**   Programa: bcapi007 - API de Impressao de Etiquetas conforme LAYOUT
**
**   Parametros: tt-etiqueta-aux - Temp-Table de Etiqueta Auxiliar
**               tt-erro - Apos a execucao da API contera  os  possiveis
**                         erros de criacao de etiquetas
**
**   Versao de Integracao: 1 - Luciano (07/98)
**
**   Nov/2000 - Alcides
**   ==================
**   - API pode ser chamada para somente gerar um teste da etiqueta. Neste
**     caso a variavel global vg-teste-etiqueta Ç setada como yes, e n∆o 
**     se verifica o tipo de transaá∆o. Gera os dados em tt-etiqueta-aux.arquivo.
**   - Passa a usar o include bc0103.i para ler os campos de impress∆o da
**     etiqueta.
**   - Mudanáa no destino de impress∆o, pode ser de 3 destinos
**      1-Arquivo, 2-Impressora EMS, 3-MSWord (ver bc0103.i)
**   - A temp table tt-etiqueta-aux pode receber tipos diferentes de destino
**     para as etiquetas. ê feito o tratamento de abertura e fechamento do
**     destino de geracao de acordo com o tipo-etiqueta.
**   - As variaveis l-impress-ems, l-msword e c-saida controlam a logica do
**     do programa. A logica se baseia no seguinte:
**     - Quando l-impress-ems = yes usa a rotina de impress∆o do ems
**     - Quando l-impress-ems = no significa que est† jogando para arquivo (em c-saida), neste
**       caso tambÇm usa l-msword para fazer a integraá∆o com o Word
**     - A integraá∆o com o word usa as variaveis c-campo-msword 
**       para primeiro guardar os campos e depois enviar para o arquivo (c-saida),
**       quando encontrar campo msword ou terminar os campos do registro.
**   - O programa mantÇm compatibilidade com as etiquetas antigas. Veja 
**     coment†rios no inicio do programa bcapi002.p.
**   - Gera um arquivo diferente para cada tipo-etiqueta (quando tipo-destino =
**     arquivo), acrescentando uma letra no nome do arquivo.
**     Ex.: 1234A.ETQ, 1234B.ETQ,...
**   - Passa a retornar uma variavel com todos os arquivo gerados.
**************************************************************************/

/* VERSAO DE INTEGRACAO */
&SCOPED-DEFINE Versao-Integracao 1

{cdp/cd0666.i}   /* definicao da temp-table de tt-erros */
{bcp/bcapi002.i} /* Definicao da temp-table de tt-etiquetas */


/* FK inicio - definicoes */
{include/i_dbvers.i} /* FK - para pegar a versao */

/* Var para guardar o layout da etiqueta */
&IF "{&mgcld_version}" >= "2.04" &THEN
    DEFINE NEW GLOBAL SHARED VARIABLE i-cod-layout NO-UNDO LIKE bc-etiqueta.cod-layout. 
&endif

DEFINE TEMP-TABLE tt-etiqueta-layout NO-UNDO LIKE tt-etiqueta .
DEF VAR c-relacao-arquivos         AS CHARACTER  NO-UNDO.
DEF VAR c-antes-execucao-upc       AS CHARACTER  NO-UNDO.
DEF VAR c-depois-execucao-upc      AS CHARACTER  NO-UNDO.
DEF VAR c-registros-tt-epc         AS CHARACTER  NO-UNDO.
DEF VAR cArquivoEtiqueta           AS CHARACTER  NO-UNDO.
DEF VAR iTipoEtiqueta              AS INTEGER    NO-UNDO.
DEF VAR cDispositivoCOM            AS CHARACTER  NO-UNDO.
DEF VAR cComandos                  AS CHARACTER  NO-UNDO.
DEF VAR v_num_cont                 AS INTEGER    NO-UNDO.
DEF VAR i-Cloud                    AS INTEGER    NO-UNDO.

/*** Definicao da temp-table tt-epc ***/
{include/i-epc200.i bcapi007}
{utp/utapi027.i}

DEF TEMP-TABLE tt-etiqueta-aux NO-UNDO LIKE tt-etiqueta.
DEF BUFFER b-tt-etiqueta-aux FOR tt-etiqueta-aux.

DEF INPUT-OUTPUT PARAM TABLE FOR tt-etiqueta-aux.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.
DEF OUTPUT PARAM p-rel-arq AS CHARACTER NO-UNDO.

/* Temp-table para retorno de erro */
DEFINE TEMP-TABLE RowErrors NO-UNDO
            FIELD ErrorSequence    AS INTEGER
            FIELD ErrorNumber      AS INTEGER
            FIELD ErrorDescription AS CHARACTER
            FIELD ErrorParameters  AS CHARACTER
            FIELD ErrorType        AS CHARACTER
            FIELD ErrorHelp        AS CHARACTER
            FIELD ErrorSubType     AS CHARACTER.

/* Variaveis para controle da abertura/fechamento do destino de geraá∆o -*/
DEFINE STREAM s-etiqueta.
DEFINE STREAM stLeon.

DEF VAR c-saida             AS CHARACTER NO-UNDO.
DEF VAR c-letra-arquivo     AS CHARACTER NO-UNDO INIT "A".
DEF VAR l-impress-ems       AS LOGICAL   NO-UNDO.
DEF VAR l-msword            AS LOGICAL   NO-UNDO.
DEF VAR l-libre             AS LOGICAL   NO-UNDO.
DEF VAR h-imprime           AS HANDLE    NO-UNDO.
DEF VAR i-tipo-etiq-ant     AS INTEGER   NO-UNDO INIT ?.
DEF VAR v_num_count         AS INTEGER   NO-UNDO.
DEF VAR l-dispositivo-COM   AS LOGICAL   NO-UNDO INIT NO.
DEF VAR l-numerico          AS LOGICAL   NO-UNDO INIT NO.
DEF VAR i-etiq-tot          AS INTEGER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHARACTER FORMAT "x(12)" LABEL "Usu†rio Corrente" COLUMN-LABEL "Usu†rio Corrente" NO-UNDO.

/* Variaveis de trabalho ------------------------------------------------*/
DEF VAR c-formato           AS CHARACTER NO-UNDO.

/* Variaveis auxiliares para tratamento do destino MSWord ----------------*/
DEF VAR c-campo-msword      AS CHARACTER NO-UNDO.
DEF VAR c-nome-msword       AS CHARACTER NO-UNDO.

/* Vari†veis para geraá∆o do c¢digo de barra -----------------------------*/
DEF VAR h-barcode           AS HANDLE    NO-UNDO.

/* Variavel para indicar execuá∆o de teste -------------------------------*/
DEF NEW GLOBAL SHARED VAR vg-teste-etiqueta     AS LOGICAL   NO-UNDO.
DEF NEW GLOBAL SHARED VAR vg-geracao-word       AS CHARACTER NO-UNDO.
DEF NEW GLOBAL SHARED VAR vg-impres-ems-teste   AS CHARACTER NO-UNDO.

/* Variavel acompanhamento de etiqueta -----------------------------------*/
DEF VAR h-acomp 			    AS HANDLE    NO-UNDO.

/* Include que contÇm campos e funá‰es para tratar campos de impress∆o ---*/
{bcp/bc0103.i}
{bcp/bc0001.i1} /* Uni∆o das Inclides i01cl016.i, i02cl016.i, i03cl016.i    */

{utp/ut-liter.i "Antes_da_execuá∆o_do_ponto_de_UPC:" * L}
ASSIGN c-antes-execucao-upc = RETURN-VALUE.

{utp/ut-liter.i "Depois_da_execuá∆o_do_Ponto_de_UPC:" * L}
ASSIGN c-depois-execucao-upc = RETURN-VALUE.

{utp/ut-liter.i "Registros temp-table tt-epc:" * L}
ASSIGN c-registros-tt-epc = RETURN-VALUE.

FIND FIRST param-bc NO-LOCK NO-ERROR.
FIND FIRST param-rfid NO-LOCK NO-ERROR.

/* Validaá‰es dos registros de tt-etiqueta-aux ---------------------------*/
FOR EACH tt-etiqueta-aux
   BREAK BY tt-etiqueta-aux.tipo-etiq:

   /* Faz a validaá∆o para cada tipo-etiqueta que est† na temp-table ----*/
   IF FIRST-OF(tt-etiqueta-aux.tipo-etiq) THEN DO:
      /* Valida se existe o tipo-etiqueta ------------------------------*/
      FIND FIRST tipo-etiqueta
           WHERE tipo-etiqueta.tipo-etiq = tt-etiqueta-aux.tipo-etiq NO-LOCK NO-ERROR.
      IF NOT AVAIL tipo-etiqueta  THEN DO:
         {utp/ut-table.i mgcld tipo-etiqueta 1}
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 2,
                           INPUT TRIM(RETURN-VALUE)).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-etiqueta-aux.i-sequen
                tt-erro.cd-erro  = 2
                tt-erro.mensagem = RETURN-VALUE.
         
         {utp/ut-liter.i "Criaá∆o Etiqueta" * L}
         ASSIGN tt-erro.mensagem = tt-erro.mensagem + " (" + RETURN-VALUE + ")".              
         RETURN "NOK":U.
      END.

      /* Valida tipo de transacao (se n∆o for teste-etiqueta) -----------*/
      IF NOT vg-teste-etiqueta THEN DO:
         FIND FIRST bc-tipo-trans
              WHERE bc-tipo-trans.cd-trans = tt-etiqueta-aux.cd-trans NO-LOCK NO-ERROR.
         IF NOT AVAIL bc-tipo-trans THEN DO:
            {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
            RUN utp/ut-msgs.p(INPUT "MSG":U,
                              INPUT 56,
                              INPUT TRIM(RETURN-VALUE)).
            
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = tt-etiqueta-aux.i-sequen
                   tt-erro.cd-erro  = 56
                   tt-erro.mensagem = RETURN-VALUE.
            
            {utp/ut-liter.i "Criaá∆o Etiqueta" * L}
            ASSIGN tt-erro.mensagem = tt-erro.mensagem + " (" + RETURN-VALUE + ")".        
            RETURN "NOK":U.
         END.
      END.

      /* Teste da versao de integracao ----------------------------------*/
      IF tt-etiqueta-aux.cod-versao-integracao <> {&Versao-Integracao} THEN DO:
         RUN utp/ut-msgs.p(INPUT "MSG":U,
                           INPUT 3941,
                           INPUT "":U).
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = tt-etiqueta-aux.i-sequen
                tt-erro.cd-erro  = 3941
                tt-erro.mensagem = RETURN-VALUE.
         
         {utp/ut-liter.i "Criaá∆o Etiqueta" * L}
         ASSIGN tt-erro.mensagem = tt-erro.mensagem + " (":U + RETURN-VALUE + ")":U.       
         RETURN "NOK":U.       
      END.
   END.
END.

/* Ap¢s as validaá‰es processa os registros de etiqueta -------------------*/

i-tipo-etiq-ant = ?.

processamento-etiqueta:
FOR EACH tt-etiqueta-aux:
   RUN pi-envia-layout-impressao IN THIS-PROCEDURE.

   /* A cada novo tipo de etiqueta abre destino de geraá∆o --------------*/
   IF tt-etiqueta-aux.tipo-etiq <> i-tipo-etiq-ant THEN DO:
      ASSIGN iTipoEtiqueta = tt-etiqueta-aux.tipo-etiq.
      IF i-tipo-etiq-ant <> ? THEN DO:
         RUN pi-fecha-destino (i-tipo-etiq-ant).
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN
            LEAVE.
      END.
      RUN pi-abre-destino.
      IF RETURN-VALUE = "NOK":U THEN
         LEAVE.
      
      ASSIGN i-tipo-etiq-ant = tt-etiqueta-aux.tipo-etiq.
   END.

   /* Se est† enviando para arquivo abre/reabre a cada registro ---------*/   
   IF NOT l-impress-ems THEN DO:
      RUN pi-open-stream (YES).
      IF RETURN-VALUE = "NOK":U THEN
         LEAVE.
   END.

   /***** Chamada UPC Criada conforme solicitaá∆o Cliente SIMOLDES *****/    
   RUN pi-cria-tt-epc.

   IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
      IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
         RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

         IF i-Cloud = 1 THEN
            OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
         ELSE 
            OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.

         {utp/ut-liter.i "Auxiliary-Field" *}
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-antes-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 "Return-value:":U RETURN-VALUE.
         IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Error-Status" *}
            PUT UNFORMATTED "        (BCAPI007) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
         END.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
         FOR EACH tt-epc:
            PUT UNFORMATTED "        (BCAPI007) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.
            
            {utp/ut-liter.i "BCAPI007)_:cod-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.

            {utp/ut-liter.i "BCAPI007)_:val-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.

            {utp/ut-liter.i "BCAPI007" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
         END.
         OUTPUT CLOSE.   
      END.
   END.

   {include/i-epc201.i "Auxiliary-Field"}

   IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
      IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
         RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

         IF i-Cloud = 1 THEN
            OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
         ELSE 
            OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.

         {utp/ut-liter.i "Auxiliary-Field" *}
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-depois-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 "Return-value:":U RETURN-VALUE.
         IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Error-Status" *}
            PUT UNFORMATTED "        (BCAPI007) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
         END.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
         FOR EACH tt-epc:
            PUT UNFORMATTED "        (BCAPI007) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.

            {utp/ut-liter.i "BCAPI007)_:cod-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.
 
            {utp/ut-liter.i "BCAPI007)_:val-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.
 
            {utp/ut-liter.i "BCAPI007" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
         END.
         OUTPUT CLOSE.   
      END.
   END.

   IF RETURN-VALUE = "NOK":U THEN DO:
      FIND FIRST tt-epc 
           WHERE tt-epc.cod-event     = "Auxiliary-Field":U
             AND tt-epc.cod-parameter = "Erro":U NO-LOCK NO-ERROR.
      IF AVAIL tt-epc THEN DO:
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = 1
                tt-erro.cd-erro  = INTEGER(ENTRY(1, tt-epc.val-parameter, "|"))
                tt-erro.mensagem = ENTRY(2, tt-epc.val-parameter, "|").

         RETURN "NOK":U.
      END.
   END.

   FOR EACH tt-epc:
      IF tt-epc.cod-parameter = "Auxiliar-06" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-06 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-07" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-07 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-08" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-08 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-09" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-09 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-10" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-10 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-11" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-11 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-12" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-12 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-13" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-13 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-14" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-14 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-15" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-15 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-16" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-16 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-17" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-17 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-18" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-18 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-19" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-19 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "Auxiliar-20" THEN
         ASSIGN tt-etiqueta-aux.auxiliar-20 = tt-epc.val-parameter.

      IF tt-epc.cod-parameter = "tipo-etiq" THEN
         ASSIGN tt-etiqueta-aux.tipo-etiq = INTEGER(tt-epc.val-parameter).

      IF tt-epc.cod-parameter = "cod-complementar" THEN
         ASSIGN tt-etiqueta-aux.cod-complementar = tt-epc.val-parameter.
   END.
   EMPTY TEMP-TABLE tt-dados.
         
   FOR EACH seq-tipo-etiqueta
      WHERE seq-tipo-etiqueta.tipo-etiq = tt-etiqueta-aux.tipo-etiq NO-LOCK
         BY seq-tipo-etiqueta.sequencia:

      ASSIGN c-formato  = seq-tipo-etiqueta.char-1
             l-numerico = NO.

      CASE INTEGER(TRUNCATE(seq-tipo-etiqueta.cod-campo / 1000, 0)) :
         WHEN 1 THEN DO: /* N£mero da Transaá∆o  */
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.nr-trans)).
         END.
         WHEN 2 THEN DO: /* Cod Ènico            */
            IF tt-etiqueta-aux.cod-unico = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.cod-unico = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.cod-unico).
         END.
         WHEN 3 THEN DO: /* C¢digo do Item  1    */
            IF tt-etiqueta-aux.it-codigo = "" AND i-tipo-destino = 3 THEN
                ASSIGN tt-etiqueta-aux.it-codigo = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.it-codigo).
         END.
         WHEN 4 THEN DO: /* Data Impress∆o       */
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.dt-impressao,"99/99/9999")).
         END.
         WHEN 5 THEN DO: /* Dt Validade Lote     */
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.dt-val-lote,"99/99/9999")).
         END.
         WHEN 6 THEN DO: /* Dep¢sito             */
            IF tt-etiqueta-aux.cod-depos = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.cod-depos = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.cod-depos).
         END.
         WHEN 7 THEN DO: /* Descriá∆o do Item    */
            IF tt-etiqueta-aux.desc-item = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.desc-item = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.desc-item).
         END.
         WHEN 8 THEN DO: /* Estabelecimento      */
            IF tt-etiqueta-aux.cod-estabel = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.cod-estabel = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.cod-estabel).
         END.
         WHEN 9 THEN DO: /* Hora Impress∆o       */
            IF tt-etiqueta-aux.hora-impressao = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.hora-impressao = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.hora-impressao).
         END.
         WHEN 10 THEN DO: /* Localizaá∆o         */
            IF tt-etiqueta-aux.cod-localiz = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.cod-localiz = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.cod-localiz).
         END.
         WHEN 11 THEN DO: /* Lote/Num SÇrie       */
            IF tt-etiqueta-aux.lote = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.lote = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.lote).
         END.
         WHEN 12 THEN DO: /* Num do Documento     */
            IF tt-etiqueta-aux.nr-docto = "" AND i-tipo-destino = 3 THEN
                ASSIGN tt-etiqueta-aux.nr-docto = CHR(13).
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.nr-docto,c-formato)).
         END.
         WHEN 13 THEN DO: /* Quantidade           */
             ASSIGN l-numerico = YES.
             RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.quantidade,c-formato)).
         END.
         WHEN 14 THEN DO: /* Referància           */
            IF tt-etiqueta-aux.cod-referencia = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.cod-referencia = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.cod-referencia).
         END.
         WHEN 15 THEN DO: /* T°tulo               */
            IF tt-etiqueta-aux.desc-etiqueta = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.desc-etiqueta = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.desc-etiqueta).
         END.
         WHEN 16 THEN DO: /* Observaá∆o           */
            IF tt-etiqueta-aux.observacao = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.observacao = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.observacao).
         END.
         WHEN 17 THEN DO: /* Constante            */
            ASSIGN c-formato = "X(" + STRING(LENGTH(seq-tipo-etiqueta.char-1),"999") + ")".
            RUN pi-imprime(INPUT seq-tipo-etiqueta.char-1).
         END.
         WHEN 18 THEN DO: /* Nova Linha           */
            IF NOT l-dispositivo-COM THEN
               PUT STREAM s-etiqueta UNFORMATTED CHR(10).
            ELSE DO:
               PUT STREAM stLeon UNFORMATTED CHR(10).
            END.
         END.
         WHEN 19 THEN DO: /* Branco               */
            RUN pi-imprime(INPUT "":U).
         END.
         WHEN 20 THEN DO: /* Auxiliar 01          */
            IF tt-etiqueta-aux.auxiliar-01 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-01 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-01).                
         END.
         WHEN 21 THEN DO: /* Auxiliar 02          */
            IF tt-etiqueta-aux.auxiliar-02 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-02 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-02).
         END.
         WHEN 22 THEN DO: /* Auxiliar 03          */
            IF tt-etiqueta-aux.auxiliar-03 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-03 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-03).
         END.
         WHEN 23 THEN DO: /* Auxiliar 04          */
            IF tt-etiqueta-aux.auxiliar-04 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-04 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-04).
         END.
         WHEN 24 THEN DO: /* Auxiliar 05          */
            IF tt-etiqueta-aux.auxiliar-05 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-05 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-05).
         END.
         WHEN 25 THEN DO: /* Auxiliar 06          */
            IF tt-etiqueta-aux.auxiliar-06 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-06 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-06).
         END.
         WHEN 26 THEN DO: /* Auxiliar 07          */
            IF tt-etiqueta-aux.auxiliar-07 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-07 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-07).
         END.
         WHEN 27 THEN DO: /* Auxiliar 08          */
            IF tt-etiqueta-aux.auxiliar-08 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-08 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-08).
         END.
         WHEN 28 THEN DO: /* Auxiliar 09          */
            IF tt-etiqueta-aux.auxiliar-09 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-09 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-09).
         END.
         WHEN 29 THEN DO: /* Auxiliar 10          */
            IF tt-etiqueta-aux.auxiliar-10 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-10 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-10).
         END.
         WHEN 30 THEN DO: /* Serie do Documento  */
            IF tt-etiqueta-aux.serie-docto = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.serie-docto = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.serie-docto).
         END.
         WHEN 31 THEN DO: /* Codigo do Emitente   */
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.cod-emitente,c-formato)).                
         END.
         WHEN 32 THEN DO: /* Natureza de Operacao */
            IF tt-etiqueta-aux.nat-operacao = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.nat-operacao = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.nat-operacao).
         END.
         WHEN 33 THEN DO: /* Numero da Transaá∆o Origem */
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.nr-trans-ant,c-formato)).
         END.
         WHEN 34 THEN DO: /* Data do Movimento    */
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.data-movimento,"99/99/9999")).
         END.
         WHEN 35 THEN DO: /* ~\                    */
            RUN pi-imprime(INPUT "~\").
         END.
         WHEN 36 THEN DO: /* /                    */
            RUN pi-imprime(INPUT "/").
         END.
         WHEN 37 THEN DO: /* *                    */
            RUN pi-imprime(INPUT "*").
         END.
         WHEN 38 THEN DO: /* |                    */
            RUN pi-imprime(INPUT "|").
         END.
         WHEN 39 THEN DO: /* ;                    */
            RUN pi-imprime(INPUT ";").
         END.
         WHEN 40 THEN DO: /* :                    */
            RUN pi-imprime(INPUT ":").
         END.
         WHEN 41 THEN DO: /* +                    */
            RUN pi-imprime(INPUT "+").
         END.
         WHEN 42 THEN DO: /* -                    */
            RUN pi-imprime(INPUT "-").
         END.
         WHEN 43 THEN DO: /* #                    */
            RUN pi-imprime(INPUT "#").
         END.
         WHEN 44 THEN DO: /* !                    */
            RUN pi-imprime(INPUT "!").
         END.
         WHEN 45 THEN DO: /* &                    */
            RUN pi-imprime(INPUT "&").
         END.
         WHEN 46 THEN DO: /* $                    */
            RUN pi-imprime(INPUT "$").
         END.
         WHEN 47 THEN DO: /* Item Externo-1   */
            IF tt-etiqueta-aux.it-codigo-ext-1 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.it-codigo-ext-1 = CHR(13).
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.it-codigo-ext-1)).
         END.
         WHEN 48 THEN DO: /* Item Externo-2   */
            IF tt-etiqueta-aux.it-codigo-ext-2 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.it-codigo-ext-2 = CHR(13).
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.it-codigo-ext-2)).
         END.
         WHEN 49 THEN DO: /* Item Externo-3   */
            IF tt-etiqueta-aux.it-codigo-ext-3 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.it-codigo-ext-3 = CHR(13).
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.it-codigo-ext-3)).
         END.
         WHEN 50 THEN DO: /* Item Externo-4   */
            IF tt-etiqueta-aux.it-codigo-ext-4 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.it-codigo-ext-4 = CHR(13).
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.it-codigo-ext-4)).
         END.
         WHEN 51 THEN DO: /* Peso Bruto      */
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.peso-bruto,c-formato)).
         END.
         WHEN 52 THEN DO: /* Peso Liquido     */
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.peso-liquido,c-formato)).
         END.
         WHEN 53 THEN DO: /* Nr.Embalagem */
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.nr-embalagem,c-formato)).
         END.
         WHEN 54 THEN DO: /* Sequencia*/
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.i-sequen,c-formato)).
         END.
         WHEN 55 THEN DO: /* Auxiliar 11          */
            IF tt-etiqueta-aux.auxiliar-11 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-11 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-11).
         END.
         WHEN 56 THEN DO: /* Auxiliar 12          */
            IF tt-etiqueta-aux.auxiliar-12 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-12 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-12).
         END.
         WHEN 57 THEN DO: /* Auxiliar 13          */
            IF tt-etiqueta-aux.auxiliar-13 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-13 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-13).
         END.
         WHEN 58 THEN DO: /* Auxiliar 14          */
            IF tt-etiqueta-aux.auxiliar-14 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-14 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-14).
         END.
         WHEN 59 THEN DO: /* Auxiliar 15          */
            IF tt-etiqueta-aux.auxiliar-15 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-15 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-15).
         END.
         WHEN 60 THEN DO: /* Auxiliar 16          */
            IF tt-etiqueta-aux.auxiliar-16 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-16 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-16).
         END.
         WHEN 61 THEN DO: /* Auxiliar 17          */
            IF tt-etiqueta-aux.auxiliar-17 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-17 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-17).
         END.
         WHEN 62 THEN DO: /* Auxiliar 18          */
            IF tt-etiqueta-aux.auxiliar-18 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-18 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-18).
         END.
         WHEN 63 THEN DO: /* Auxiliar 19          */
            IF tt-etiqueta-aux.auxiliar-19 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-19 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-19).
         END.
         WHEN 64 THEN DO: /* Auxiliar 20          */
            IF tt-etiqueta-aux.auxiliar-20 = "" AND i-tipo-destino = 3 THEN
               ASSIGN tt-etiqueta-aux.auxiliar-20 = CHR(13).
            RUN pi-imprime(INPUT tt-etiqueta-aux.auxiliar-20).
         END.
         WHEN 65 THEN DO: /* Campo MSWord */
            CREATE tt-dados.
            IF LENGTH(c-campo-msword) <> 0 THEN DO:
               RUN pi-imprime-campo-msword (tt-etiqueta-aux.tipo-etiq).
               ASSIGN tt-dados.campo-valor = c-campo-msword.
            END. 
            ASSIGN c-nome-msword  = seq-tipo-etiqueta.char-1. /* conteudo */ 

            ASSIGN tt-dados.campo-nome = c-nome-msword
                   tt-dados.campo-tipo = 3.

            ASSIGN c-campo-msword = "":U.
         END.
   		WHEN 66 THEN DO: /* cod-complementar */
   			ASSIGN tt-etiqueta-aux.cod-complementar = TRIM(tt-etiqueta-aux.cod-complementar).
            RUN pi-imprime(INPUT tt-etiqueta-aux.cod-complementar).
         END.
   		WHEN 67 THEN DO: /* rfid-epc-totvs */
   			ASSIGN tt-etiqueta-aux.rfid-epc-totvs = TRIM(tt-etiqueta-aux.rfid-epc-totvs)
   				    l-numerico = NO.	   
            RUN pi-imprime(INPUT tt-etiqueta-aux.rfid-epc-totvs).
         END.
   		WHEN 68 THEN DO: /* rfid-epc-gs1 */
   			ASSIGN tt-etiqueta-aux.rfid-epc-gs1 = TRIM(tt-etiqueta-aux.rfid-epc-gs1)
   				    l-numerico = NO.	   
            RUN pi-imprime(INPUT tt-etiqueta-aux.rfid-epc-gs1).
         END.
   		WHEN 69 THEN DO: /* rfid-cod-gtin */
   			ASSIGN tt-etiqueta-aux.rfid-cod-gtin = TRIM(tt-etiqueta-aux.rfid-cod-gtin)
   				    l-numerico = NO.	   
            RUN pi-imprime(INPUT tt-etiqueta-aux.rfid-cod-gtin).
         END.
   		WHEN 70 THEN DO: /* rfid-sequencial */
            ASSIGN l-numerico = YES.
            RUN pi-imprime(INPUT STRING(tt-etiqueta-aux.rfid-sequencial,c-formato)).
         END.
      END.

      /* erro de convers∆o */
      IF RETURN-VALUE = "NOK":U THEN DO:
         RUN pi-close-stream.
         LEAVE processamento-etiqueta.
      END.
   END.

	FIND FIRST tt-epc
	     WHERE tt-epc.cod-parameter = "lote":U NO-LOCK NO-ERROR.

	EMPTY TEMP-TABLE RowErrors.
	EMPTY TEMP-TABLE tt-erro.
			
	IF NOT AVAIL item THEN
      FIND FIRST item
           WHERE item.it-codigo = tt-etiqueta-aux.it-codigo NO-LOCK NO-ERROR.

	IF AVAIL param-rfid AND param-rfid.log-ativo THEN DO:
      IF (tt-etiqueta-aux.rfid-epc-totvs <> "0" AND tt-etiqueta-aux.rfid-epc-totvs <> "")
         OR (tt-etiqueta-aux.rfid-epc-gs1 <> "0" AND tt-etiqueta-aux.rfid-epc-gs1 <> "") THEN DO:
         
         FIND FIRST prog_dtsul
              WHERE prog_dtsul.cod_prog_dtsul = "bcapi007" NO-LOCK NO-ERROR.
         IF AVAIL prog_dtsul THEN DO:
            ASSIGN c-nom-prog-dpc-mg97  = prog_dtsul.nom_prog_dpc
                   c-nom-prog-appc-mg97 = prog_dtsul.nom_prog_appc
                   c-nom-prog-upc-mg97  = prog_dtsul.nom_prog_upc.
                   
            IF (c-nom-prog-upc-mg97 <> "") THEN DO:
               RUN men/verifyDisableUPC.p (output lDisableUPC).
               IF lDisableUPC THEN
                  ASSIGN c-nom-prog-upc-mg97 = "".
            END.             
         END.
            
         IF c-nom-prog-dpc-mg97  <> "" OR c-nom-prog-upc-mg97  <> "" OR c-nom-prog-appc-mg97 <> "" THEN DO:
            FOR EACH tt-epc
               WHERE tt-epc.cod-event = "After-process-tag":
               DELETE tt-epc.
            END.
            
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event    = "After-process-tag"
                   tt-epc.cod-parameter = "handle-tt-etiqueta-aux"
                   tt-epc.val-parameter = STRING(TEMP-TABLE tt-etiqueta-aux:HANDLE).
            
            {include/i-epc201.i "After-process-tag"}
         END.
			
			IF RETURN-VALUE <> "OK":U THEN DO:
				FOR EACH RowErrors NO-LOCK:
					CREATE tt-erro.
					ASSIGN tt-erro.i-sequen = RowErrors.ErrorSequence 
						    tt-erro.cd-erro  = RowErrors.ErrorNumber
						    tt-erro.mensagem = RowErrors.ErrorDescription.
				END.
				RETURN "NOK":U.
			END.
		END.
	END.
	
   /* Imprime o ultimo campo msword quando necess†rio */
   IF (l-msword OR l-libre) AND LENGTH(c-campo-msword) <> 0 THEN DO:
      RUN pi-imprime-campo-msword (tt-etiqueta-aux.tipo-etiq).

      ASSIGN tt-dados.campo-valor = c-campo-msword.
   END.

   /* Pula linha e fecha arquivo (se for o caso) */
   IF l-impress-ems THEN DO:
      IF NOT l-dispositivo-COM THEN
         PUT STREAM s-etiqueta SKIP. 
      ELSE
         PUT STREAM stLeon SKIP.
   END.    
   ELSE DO:
      IF l-msword OR l-libre THEN
         PUT STREAM s-etiqueta "~\par":U SKIP.
      ELSE
         PUT STREAM s-etiqueta SKIP.

      RUN pi-close-stream.
   END.

   /* Inicio Ponto EPC - FO 1306.203 */
   EMPTY TEMP-TABLE tt-epc.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event        = "infor-etiqueta":U
          tt-epc.cod-parameter    = "cd-trans":U
          tt-epc.val-parameter    =  tt-etiqueta-aux.cd-trans.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event        = "infor-etiqueta":U
          tt-epc.cod-parameter    = "nr-trans":U
          tt-epc.val-parameter    =  STRING(tt-etiqueta-aux.nr-trans).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event        = "infor-etiqueta":U
          tt-epc.cod-parameter    = "tipo-etiq":U
          tt-epc.val-parameter    =  STRING(tt-etiqueta-aux.tipo-etiq).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event        = "infor-etiqueta":U
          tt-epc.cod-parameter    = "c-saida":U
          tt-epc.val-parameter    =  c-saida.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event        = "infor-etiqueta":U
          tt-epc.cod-parameter    = "i-tipo-destino":U
          tt-epc.val-parameter    =  STRING(i-tipo-destino).

   IF c-nom-prog-upc-mg97   <> "" AND c-nom-prog-upc-mg97   <> ?  THEN DO:
      IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
         RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

         IF i-Cloud = 1 THEN
            OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
         ELSE 
            OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.

         {utp/ut-liter.i "infor-etiqueta" *}
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-antes-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 "Return-value:":U RETURN-VALUE.
         IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Error-Status" *}
            PUT UNFORMATTED "        (BCAPI007) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
         END.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
         FOR EACH tt-epc:
             PUT UNFORMATTED "        (BCAPI007) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.

             {utp/ut-liter.i "BCAPI007)_:cod-parameter" *}
             PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.

             {utp/ut-liter.i "BCAPI007)_:val-parameter" *}
             PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.

             {utp/ut-liter.i "BCAPI007" *}
             PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
         END.
         OUTPUT CLOSE.   
      END.
   END.

   {include/i-epc201.i "infor-etiqueta"}

   /* Termino Ponto EPC - FO 1306.203 */
   IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
      IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
         RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

         IF i-Cloud = 1 THEN
            OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
         ELSE 
            OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.

         {utp/ut-liter.i "infor-etiqueta" *}
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-depois-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 "Return-value:":U RETURN-VALUE.
         IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Error-Status" *}
            PUT UNFORMATTED "        (BCAPI007) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
         END.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
         FOR EACH tt-epc:
            PUT UNFORMATTED "        (BCAPI007) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.

            {utp/ut-liter.i "BCAPI007)_:cod-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.

            {utp/ut-liter.i "BCAPI007)_:val-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.

            {utp/ut-liter.i "BCAPI007" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
         END.
         OUTPUT CLOSE.   
      END.
   END.
END.

/* Se usou a API de c¢digo de barra limpa a mesma da mem¢ria ------------*/
IF VALID-HANDLE (h-barcode) THEN
   DELETE PROCEDURE h-barcode.

/* fecha destino de impress∆o para ultima etiqueta processada ------------*/
FIND FIRST tt-erro NO-ERROR.
IF NOT AVAIL tt-erro AND i-tipo-etiq-ant <> ? THEN
   RUN pi-fecha-destino (i-tipo-etiq-ant).

FIND FIRST tt-erro NO-ERROR.
IF AVAIL tt-erro THEN
   RETURN "NOK":U.
ELSE
   RETURN "OK":U.

PROCEDURE pi-imprime:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEF INPUT PARAM pi-auxiliar   AS CHARACTER NO-UNDO.

   DEF VAR i-campo            AS INTEGER             NO-UNDO.
   DEF VAR c-campo-formatado  AS CHARACTER           NO-UNDO.
   DEF VAR de-decimal         AS DECIMAL DECIMALS 10 NO-UNDO.
   DEF VAR i-inicio           AS INTEGER             NO-UNDO.
   DEF VAR i-tamanho          AS INTEGER             NO-UNDO.
   DEF VAR c-trim             AS CHARACTER           NO-UNDO. /* FO 878.055 - Denis - Hutchinson */


   /* Primeiro formata o campo em c-campo-formatado --------------------------*/
   IF seq-tipo-etiqueta.int-1 = 2             /* Numerico */
      OR seq-tipo-etiqueta.int-1 = 3 THEN DO: /* Numero com Zeros a esquerda  */
   
      ASSIGN de-decimal = DECIMAL(pi-auxiliar) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
         {utp/ut-liter.i " do Campo" * L}
         RUN utp/ut-msgs.p (INPUT "MSG":U,
                            INPUT 15967,
                            INPUT TRIM(RETURN-VALUE)).

         CREATE tt-erro.
         ASSIGN i-campo = INTEGER(TRUNCATE(seq-tipo-etiqueta.cod-campo / 1000, 0))
                tt-erro.i-sequen = 1
                tt-erro.cd-erro  = 15967
                tt-erro.mensagem =  RETURN-VALUE + " ( " + TRIM(SUBSTRING(ENTRY(i-campo,c-lista),1,23)) + " ) ".

         {utp/ut-liter.i "com conte£do" * L}
         ASSIGN tt-erro.mensagem =  tt-erro.mensagem + TRIM(RETURN-VALUE) + " ( " + pi-auxiliar + " )".

         {utp/ut-liter.i "para N£mÇrico" * L}
         ASSIGN tt-erro.mensagem = tt-erro.mensagem + " " + TRIM(RETURN-VALUE).

         {utp/ut-liter.i "Criaá∆o Etiqueta" * L}
         ASSIGN tt-erro.mensagem = tt-erro.mensagem + " (" + RETURN-VALUE + ")".

         RETURN "NOK":U.
      END.
      ASSIGN c-campo-formatado = TRIM(STRING(de-decimal, c-formato)) NO-ERROR.
      IF ERROR-STATUS:NUM-MESSAGES > 1 THEN DO:
         ASSIGN i-campo = INTEGER(TRUNCATE(seq-tipo-etiqueta.cod-campo / 1000, 0)).
         RUN utp/ut-msgs.p("msg":U,
                           25739, 
                           c-formato + "~~":U + TRIM(SUBSTRING(ENTRY(i-campo,c-lista),1,23)) + "~~":U + STRING(de-decimal)).
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = 1
                tt-erro.cd-erro  = 25739
                tt-erro.mensagem = RETURN-VALUE.
         
         RETURN "NOK":U.
      END.
   END.
   ELSE DO:
      /* campos tipo data */
      IF CAN-DO("4,5,34", STRING(INTEGER(TRUNCATE(seq-tipo-etiqueta.cod-campo / 1000,0)))) THEN DO:
         ASSIGN c-campo-formatado = pi-auxiliar.

         CASE seq-tipo-etiqueta.char-1:
            WHEN "DD" THEN DO:
               ASSIGN c-campo-formatado = STRING(DAY(DATE(pi-auxiliar)),"99").
            END.
            WHEN "MM" THEN DO:
               ASSIGN c-campo-formatado = STRING(MONTH(DATE(pi-auxiliar)),"99").
            END.
            WHEN "AA" THEN DO:
               ASSIGN c-campo-formatado = SUBSTR(STRING(YEAR(DATE(pi-auxiliar)),"9999"),3).
            END.
            WHEN "AAAA" THEN DO:
               ASSIGN c-campo-formatado = STRING(YEAR(DATE(pi-auxiliar)),"9999").
            END.
            WHEN "DD/MM/AA" THEN DO:
               ASSIGN c-campo-formatado = STRING(DATE(pi-auxiliar),"99/99/99").
            END.
            WHEN "DD/MM/AAAA" THEN DO:
               ASSIGN c-campo-formatado = STRING(DATE(pi-auxiliar),"99/99/9999").
            END.
         END.
      END.
      ELSE DO: /* campos texto normal */ 
         ASSIGN c-trim    = c-formato
                c-formato = REPLACE(c-formato,"LEFT-TRIM","")
                c-formato = REPLACE(c-formato,"RIGHT-TRIM","")
                c-formato = REPLACE(c-formato,"TRIM","")
                i-inicio  = MAX(1,seq-tipo-etiqueta.int-2)
                i-tamanho = seq-tipo-etiqueta.dec-1.


         IF i-tamanho = 0 THEN
            ASSIGN c-campo-formatado = SUBSTR(pi-auxiliar, i-inicio).
         ELSE
            ASSIGN c-campo-formatado = SUBSTR(pi-auxiliar, i-inicio,i-tamanho).

         IF NOT l-numerico THEN 
            ASSIGN c-campo-formatado = STRING(SUBSTR(pi-auxiliar, i-inicio),c-formato).

         /* Inicio - Retirar Espacos */
         IF INDEX(c-TRIM,"TRIM":U) <> 0 THEN DO:
            IF INDEX(c-TRIM,"LEFT":U) <> 0 THEN
               ASSIGN c-campo-formatado = LEFT-TRIM(pi-auxiliar).

            IF INDEX(c-TRIM,"RIGHT":U) <> 0 THEN
               ASSIGN c-campo-formatado = RIGHT-TRIM(pi-auxiliar).

            IF INDEX(c-TRIM,"LEFT":U)  = 0 AND INDEX(c-TRIM,"RIGHT":U) = 0 THEN
               ASSIGN c-campo-formatado = TRIM(pi-auxiliar).
         END.

         /* Caso campo n∆o possuir conteudo deixar um branco por causa do word **/
         IF LENGTH(c-campo-formatado) = 0 AND (l-msword or l-libre) THEN DO:
            ASSIGN C-CAMPO-FORMATADO = " ".
         END.
      END.
   END.

   /* Imprime o campo de acordo com o tipo-destino */
   IF l-impress-ems THEN DO:
      IF NOT l-dispositivo-COM THEN
         PUT STREAM s-etiqueta UNFORMATTED c-campo-formatado. 
      ELSE
         PUT STREAM stLeon UNFORMATTED c-campo-formatado.
   END.    
   ELSE DO:
      IF l-msword OR l-libre THEN DO:
         ASSIGN c-campo-msword = c-campo-msword + c-campo-formatado.
         IF AVAIL tt-dados THEN
            ASSIGN tt-dados.campo-valor = c-campo-msword.
      END.
      ELSE
         PUT STREAM s-etiqueta UNFORMATTED c-campo-formatado.
   END.

   RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-campo-msword:
/*------------------------------------------------------------------------------   
  Purpose: procedure para impress∆o do campo word verificando convers∆o de barcode                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/      
   DEF INPUT PARAM p-etiqueta    AS INTEGER   NO-UNDO.

   DEF VAR c-barcode             AS CHARACTER NO-UNDO.
   DEF VAR c-barcode-chars       AS CHARACTER NO-UNDO.
   DEF VAR c-barcode-erro        AS CHARACTER NO-UNDO.

   /* barcode Ç a ultima entrada do nome-msword ------------------------*/
   ASSIGN c-barcode = ENTRY(NUM-ENTRIES(c-nome-msword, "_":U), c-nome-msword, "_":U).

   IF CAN-DO("EAN13,I2of5,CODE39,EAN128A,EAN128B,EAN128C,Code128A,Code128B,Code128C", c-barcode) THEN DO:
      /* Carrega api de barcode se necess†rio */    
      IF NOT VALID-HANDLE(h-barcode) THEN
         RUN bcp/bcapi016.p PERSISTENT SET h-barcode.

      /* Converte valor do barcode para caracteres */
      RUN VALUE("generate":U + c-barcode) IN h-barcode ( INPUT c-campo-msword,
                                                         OUTPUT c-barcode-chars).
      ASSIGN c-barcode-erro = RETURN-VALUE.

      /* Erro na convers∆o do barcode */
      IF c-barcode-erro <> "":U THEN DO:
         RUN utp/ut-msgs.p("MSG":U,
                           25779,
                           c-barcode-erro).
         ASSIGN c-barcode-erro = RETURN-VALUE.
         
         {utp/ut-liter.i "TipoEtiqueta"}
         ASSIGN c-barcode-erro = c-barcode-erro + " (":U + TRIM(RETURN-VALUE) + "=":U + STRING(p-etiqueta) + ")":U.
         
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = 1
                tt-erro.cd-erro  = 25779
                tt-erro.mensagem = c-barcode-erro.
         
         RETURN "NOK":U.
      END.
      ASSIGN c-campo-msword = c-barcode-chars.
   END.

   /* substitui ~\ por ~\~\ para n∆o dar problema no arquivo .rtf ---------*/
   ASSIGN c-campo-msword = REPLACE(c-campo-msword, "~\":U, "~\~\":U).

   /* substitui { e } por ~\{ e ~\}, pois s∆o caracteres especiais do .rtf*/
   ASSIGN c-campo-msword = REPLACE(c-campo-msword, "~{":U, "~\~{":U).
   ASSIGN c-campo-msword = REPLACE(c-campo-msword, "~}":U, "~\~}":U).

   /* faz o tratamento de aspas, para n∆o dar erro no .rtf -------------*/
   IF INDEX(c-campo-msword, '"':U) > 0 THEN
      ASSIGN c-campo-msword = '"':U + REPLACE(c-campo-msword, '"':U, '""':U) + '"':U.

   /* imprime o campo msword no formato rtf ----------------------------*/
   PUT STREAM s-etiqueta UNFORMATTED c-campo-msword "~\tab ":U.

   ASSIGN c-campo-msword = "":U.
   RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-abre-destino:
/*------------------------------------------------------------------------------   
  Purpose: procedure para abertura do destino de geracao do tipo-etiqueta                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   DEF VAR c-impressora AS CHARACTER NO-UNDO.

   /* reseta vari†veis de controle */
   ASSIGN l-msword      = NO
          l-impress-ems = NO
          l-libre       = NO.

   /* define destino de geraá∆o: impressora ou arquivo (l-impress-ems) */
   FIND FIRST tipo-etiqueta 
        WHERE tipo-etiqueta.tipo-etiq = tt-etiqueta-aux.tipo-etiq NO-LOCK NO-ERROR.

   /* funá∆o do include bc0103.i */
   RUN pi-obtem-campos-impressao (BUFFER tipo-etiqueta,
                                  OUTPUT i-tipo-destino,
                                  OUTPUT c-impres-ems, 
                                  OUTPUT c-layout-ems,
                                  OUTPUT c-doc-msword, 
                                  OUTPUT c-imp-windows).

   EMPTY TEMP-TABLE tt-epc.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "SelectPrint2":U
          tt-epc.cod-parameter = "Tipo-Destino":U
          tt-epc.val-parameter = STRING(i-tipo-destino).
   
   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "SelectPrint2":U
          tt-epc.cod-parameter = "Impres-EMS":U
          tt-epc.val-parameter = c-impres-ems.
   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "SelectPrint2":U
          tt-epc.cod-parameter = "Layout-EMS":U
          tt-epc.val-parameter = c-layout-ems.
   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "SelectPrint2":U
          tt-epc.cod-parameter = "Doc-MSWord":U
          tt-epc.val-parameter = c-doc-msword.
   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "SelectPrint2":U
          tt-epc.cod-parameter = "Imp-Windows":U
          tt-epc.val-parameter = c-imp-windows.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "SelectPrint2":U
          tt-epc.cod-parameter = "Cd-trans":U
          tt-epc.val-parameter =  tt-etiqueta-aux.cd-trans.

   IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
      IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
         RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

         IF i-Cloud = 1 THEN
            OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
         ELSE 
            OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.

         /* Inicio -- Projeto Internacional */
         {utp/ut-liter.i "SelectPrint2" *}
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-antes-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 "Return-value:":U RETURN-VALUE.
         IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Error-Status" *}
            PUT UNFORMATTED "        (BCAPI007) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
         END.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
         FOR EACH tt-epc:
            PUT UNFORMATTED "        (BCAPI007) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.

            {utp/ut-liter.i "BCAPI007)_:cod-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.

            {utp/ut-liter.i "BCAPI007)_:val-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.

            {utp/ut-liter.i "BCAPI007" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
         END.
         OUTPUT CLOSE.   
      END.
   END.

   {include/i-epc201.i "SelectPrint2"}

   IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
      IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
          RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

          IF i-Cloud = 1 THEN
             OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
          ELSE 
             OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.

          {utp/ut-liter.i "SelectPrint2" *}
          PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-depois-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
          PUT UNFORMATTED "        (BCAPI007) ":U AT 1 "Return-value:":U RETURN-VALUE.
          IF ERROR-STATUS:ERROR THEN DO:
             {utp/ut-liter.i "Error-Status" *}
             PUT UNFORMATTED "        (BCAPI007) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
          END.
          PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
          FOR EACH tt-epc:
             PUT UNFORMATTED "        (BCAPI007) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.

             {utp/ut-liter.i "BCAPI007)_:cod-parameter" *}
             PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.

             {utp/ut-liter.i "BCAPI007)_:val-parameter" *}
             PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.

             {utp/ut-liter.i "BCAPI007" *}
             PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
          END.
          OUTPUT CLOSE.   
      END.
   END.

   FOR EACH tt-epc
        WHERE tt-epc.cod-event = "SelectPrint2":U NO-LOCK:

      CASE tt-epc.cod-parameter:
         WHEN "Tipo-Destino":U THEN
            ASSIGN i-tipo-destino = INTEGER(tt-epc.val-parameter).
         WHEN "Impres-EMS":U THEN  
            ASSIGN c-impres-ems = tt-epc.val-parameter.
         WHEN "Layout-EMS":U THEN  
            ASSIGN c-layout-ems = tt-epc.val-parameter.
         WHEN "Doc-MSWord":U THEN  
            ASSIGN c-doc-msword = tt-epc.val-parameter.
         WHEN "Imp-Windows":U THEN  
            ASSIGN c-imp-windows = tt-epc.val-parameter.
      END CASE.
   END.

   /* usa o destino de impress∆o da transaá∆o nestes casos ----------------------*/
   IF i-tipo-destino = 1     /* arquivo */
       OR (i-tipo-destino = 2 /* imp-ems */
      AND c-impres-ems = "":U) THEN DO:

      IF vg-teste-etiqueta THEN DO: /* assume impressora teste */
         ASSIGN c-impressora  = vg-impres-ems-teste
                l-impress-ems = (IF i-tipo-destino = 2 THEN YES ELSE NO).  /* imp-ems */
      END.
      ELSE DO: /* usar impressora da transaá∆o */
         FIND FIRST bc-tipo-trans
              WHERE bc-tipo-trans.cd-trans = tt-etiqueta-aux.cd-trans NO-LOCK NO-ERROR.
         IF AVAIL bc-tipo-trans AND bc-tipo-trans.char-2 <> "":U THEN DO:  /* quando Ç teste n∆o est† dispon°vel */
            ASSIGN c-impressora  = bc-tipo-trans.char-2
                   l-impress-ems = YES.
         END.
      END.
   END.
   ELSE DO: /* usa o destino de impress∆o que est† na etiqueta */
      IF i-tipo-destino = 2 THEN /* imp-ems */
         ASSIGN c-impressora  = c-impres-ems
                l-impress-ems = YES.
      ELSE DO:
         IF i-tipo-destino = 3 THEN /* msword */
            ASSIGN l-msword = YES.
         IF i-tipo-destino = 4 THEN /* libre */
            ASSIGN l-libre = YES.
      END.
   END.
   
   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "SelectPrint3":U
          tt-epc.cod-parameter = "nr-trans":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.nr-trans).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "SelectPrint3":U
          tt-epc.cod-parameter = "destino-impressora":U
          tt-epc.val-parameter = STRING(c-impressora).

   {include/i-epc201.i "SelectPrint3"}

   FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = "SelectPrint3":U
          AND tt-epc.cod-parameter = "destino-impressora" NO-LOCK NO-ERROR.
   IF AVAIL tt-epc THEN
      ASSIGN c-impressora = STRING(tt-epc.val-parameter).

   /* abre rotina de impress∆o */
   IF l-impress-ems THEN DO:
      FIND FIRST layout_impres
           WHERE layout_impres.nom_impressora    = c-impressora
             AND layout_impres.cod_layout_impres = c-layout-ems NO-LOCK NO-ERROR.
      IF NOT AVAIL layout_impres THEN DO:
         RUN pi-envia-erro-extratoversao( INPUT "Layout '" + TRIM(STRING(c-layout-ems)) + "', para a impressora '" + TRIM(STRING(c-impressora)) + "' n∆o cadastrado!").
         RETURN "NOK":U. 
      END.

      FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
           WHERE imprsor_usuar.nom_impressora = c-impressora
             AND imprsor_usuar.cod_usuario    = v_cod_usuar_corren NO-LOCK NO-ERROR.
      IF NOT AVAIL imprsor_usuar THEN DO:
         RUN pi-envia-erro-extratoversao( INPUT "Usu†rio '" + TRIM(STRING(v_cod_usuar_corren)) + "', para a impressora '" + TRIM(STRING(c-impressora)) + "' n∆o cadastrado!").
         RETURN "NOK":U.
      END.

      ASSIGN l-dispositivo-COM = (IF OPSYS = 'win32' AND imprsor_usuar.nom_disposit_so BEGINS 'COM' THEN YES ELSE NO)
             cDispositivoCOM   = imprsor_usuar.nom_disposit_so.

      IF l-dispositivo-COM THEN DO: /* Utilizando dispositivo COM */
         ASSIGN cArquivoEtiqueta = SESSION:TEMP-DIRECTORY + "et-" + STRING(iTipoEtiqueta,"999999") + ".VET".

         OUTPUT STREAM stLeon TO VALUE(cArquivoEtiqueta).

         /* Imprime comando definidos no layout selecionado */
         setting:
         FOR EACH configur_layout_impres
            WHERE configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres NO-LOCK
               BY configur_layout_impres.num_ord_funcao_imprsor:

            FIND FIRST configur_tip_imprsor USE-INDEX cnfgrtpm_id
                 WHERE configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                   AND configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                   AND configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor NO-LOCK NO-ERROR.

            ASSIGN cComandos = "".
            
            bloco_1:
            DO v_num_cont = 1 TO EXTENT(configur_tip_imprsor.num_carac_configur):
               IF configur_tip_imprsor.num_carac_configur[v_num_cont] = ? THEN
                  LEAVE.
               
               ASSIGN cComandos = cComandos + CHR(configur_tip_imprsor.num_carac_configur[v_num_cont]).
               
               PUT STREAM stLeon UNFORMATTED CHR(configur_tip_imprsor.num_carac_configur[v_num_cont]).
            END.
         END.
         PUT STREAM stLeon UNFORMATTED SKIP.
      END.
      ELSE DO:
         RUN pi-abrir-impressora.  /* Processo padr∆o para abertura de arquivo para impressora LPT OU REDE */
         IF RETURN-VALUE = "NOK":U THEN
            RETURN RETURN-VALUE.
      END.
   END.   
   ELSE DO: /* Define nome do arquivo de saida */
      IF vg-teste-etiqueta THEN DO:
         ASSIGN c-saida = tt-etiqueta-aux.arquivo.
         
         /* Se o arquivo existe verifica se pode gravar */
         ASSIGN FILE-INFO:FILE-NAME = c-saida.
         IF FILE-INFO:FULL-PATHNAME <> ? AND INDEX(FILE-INFO:FILE-TYPE, "W":U) = 0 THEN DO:
            RUN utp/ut-msgs.p('MSG':U,
                              25768,
                              c-saida).
            
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 25768
                   tt-erro.mensagem = RETURN-VALUE.
            RETURN "NOK":U.
         END.
      END.
      ELSE DO: 
         FIND FIRST param-bc NO-LOCK NO-ERROR.
         FIND FIRST bc-tipo-trans
              WHERE bc-tipo-trans.cd-trans = tt-etiqueta-aux.cd-trans NO-LOCK NO-ERROR.
         
         ASSIGN c-saida = (IF AVAIL param-bc THEN param-bc.nome-dir-etiq ELSE "":U)
                c-saida = c-saida + (IF bc-tipo-trans.char-1 <> "":U THEN ((IF c-saida <> "":U THEN "/":U ELSE "":U) + TRIM(bc-tipo-trans.char-1) ) ELSE "":U)
                c-saida = (IF OPSYS <> 'Win32':U AND OPSYS <> 'MSDOS':U THEN REPLACE(c-saida, "~\":U, "/":U) ELSE REPLACE(c-saida, "/":U, "~\":U)).
                
         ASSIGN FILE-INFO:FILE-NAME = (IF c-saida <> "":U THEN c-saida ELSE ".":U). /* teste de existencia do diretorio */

         ASSIGN c-saida = c-saida + (IF c-saida <> "":U THEN "/":U ELSE "":U) + tt-etiqueta-aux.arquivo
                c-saida = (IF OPSYS <> 'Win32':U AND OPSYS <> 'MSDOS':U THEN REPLACE(c-saida, "~\":U, "/":U) ELSE REPLACE(c-saida, "/":U, "~\":U)).

         /* teste do diretorio */
         IF FILE-INFO:PATHNAME = ? THEN DO:
            {utp/ut-liter.i Etiquetas_-_Diret¢rio/Arquivo * L}
            RUN utp/ut-msgs.p(INPUT "MSG":U,
                              INPUT 15891,
                              INPUT TRIM(RETURN-VALUE)).
            
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 15891
                   tt-erro.mensagem = RETURN-VALUE + " (":U + c-saida + ")":U.
            RETURN "NOK":U.
         END.

         /* Acrescenta letra no nome do arquivo antes da extens∆o .ETQ */
         IF R-INDEX(c-saida, ".":U) > 0 THEN /* tem extens∆o */
            ASSIGN c-saida = SUBSTR(c-saida, 1, R-INDEX(c-saida, ".":U) - 1) + c-letra-arquivo + SUBSTR(c-saida, R-INDEX(c-saida, ".":U)).
         ELSE
            ASSIGN c-saida = c-saida + c-letra-arquivo.

         ASSIGN c-letra-arquivo = CHR(ASC(c-letra-arquivo) + 1).

         /* atualiza lista de arquivos gerados (exceto arquivos word */
         IF NOT l-msword AND NOT l-libre THEN
            ASSIGN p-rel-arq = p-rel-arq + (IF p-rel-arq = "":U THEN "":U ELSE ",":U) + c-saida.
      END.
      
      /* Inicializa o arquivo de saida no caso do msword */
      IF l-msword OR l-libre THEN DO:
         RUN pi-open-stream (NO).
         IF RETURN-VALUE = "NOK":U THEN
            RETURN RETURN-VALUE.
         
         RUN pi-cabec-msword.
         RUN pi-close-stream.
      END.
   END.        
   RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-cabec-msword:
/*------------------------------------------------------------------------------   
  Purpose: procedure para geraá∆o do cabeáalho do msword na saida padr∆o                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/  
   /* Cabeáalho do documento de dados no formato rtf */
   PUT STREAM s-etiqueta UNFORMATTED "~{~\rtf1~\ansi~\pard~\plain":U SKIP.

   /* Gera cabeáalho para cada campo configurado da etiqueta ---------------*/
   FOR EACH seq-tipo-etiqueta
      WHERE seq-tipo-etiqueta.tipo-etiq = tt-etiqueta-aux.tipo-etiq NO-LOCK
         BY seq-tipo-etiqueta.sequencia:

       /* Imprime o nome do campo msword -----------------------------------*/
       IF INTEGER(TRUNCATE(seq-tipo-etiqueta.cod-campo / 1000, 0)) = 65 THEN
          PUT STREAM s-etiqueta UNFORMATTED seq-tipo-etiqueta.char-1 + "~\tab ":U.
   END.
   /* termina a linha do cabeáalho */
   PUT STREAM s-etiqueta UNFORMATTED "~\par":U SKIP.
END PROCEDURE.

PROCEDURE pi-open-stream:
/*------------------------------------------------------------------------------   
  Purpose: Procedure para abertura do stream de saida (execuá∆o do comando output)
           Se estiver integrando com word Ç preciso usar 'iso8859-1' (c¢digo de caracters 
           windows).                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/      
   DEF INPUT PARAM p-append   AS LOGICAL NO-UNDO.

   /* Para o caso de erro na abertura retorna "NOK" */

   /* Verifica se o Diret¢rio existe */
   DO ON ERROR UNDO, LEAVE:
      IF p-append THEN DO:
         IF l-msword OR l-libre THEN
            OUTPUT STREAM s-etiqueta TO VALUE(c-saida) CONVERT TARGET "iso8859-1":U APPEND.
         ELSE
            OUTPUT STREAM s-etiqueta TO VALUE(c-saida) APPEND.
      END.
      ELSE DO:
         IF l-msword OR l-libre THEN
            OUTPUT STREAM s-etiqueta TO VALUE(c-saida) CONVERT TARGET "iso8859-1":U.
         ELSE
            OUTPUT STREAM s-etiqueta TO VALUE(c-saida).
      END.
      RETURN "OK":U.
   END.
   RUN utp/ut-msgs.p('MSG':U,
                     25768,
                     c-saida).
   CREATE tt-erro.
   ASSIGN tt-erro.i-sequen = 1
          tt-erro.cd-erro  = 25768
          tt-erro.mensagem = RETURN-VALUE.
   RETURN "NOK":U.
END PROCEDURE.

PROCEDURE pi-fecha-destino:
/*------------------------------------------------------------------------------   
  Purpose: procedure para fechamento do destino de impress∆o do tipo-etiqueta                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   DEF INPUT PARAM p-tipo-etiqueta AS INTEGER NO-UNDO.

   IF l-impress-ems THEN DO:
      IF NOT l-dispositivo-COM THEN
         RUN pi-close-stream. 
      ELSE DO:
         OUTPUT STREAM stLeon CLOSE.
         OS-COMMAND SILENT VALUE("type " + TRIM(cArquivoEtiqueta) + " > " + TRIM(cDispositivoCOM)).
      END.
   END.

   /* se for msword reabre o arquivo para finalizar documento rtf */
   IF l-msword OR l-libre THEN DO:
      RUN pi-open-stream (YES).
      IF RETURN-VALUE = "NOK":U THEN
         RETURN.
      
      PUT STREAM s-etiqueta UNFORMATTED "~}":U SKIP.
      RUN pi-close-stream.
      RUN pi-executa-merge-msword (p-tipo-etiqueta, c-saida).
   END.
   IF VALID-HANDLE(h-imprime) THEN
      RUN destroy IN h-imprime.
END PROCEDURE.

PROCEDURE pi-close-stream:
/*------------------------------------------------------------------------------   
  Purpose: Procedure para fechamento do stream de saida (execuá∆o do comando output close)                                                                        
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   OUTPUT STREAM s-etiqueta CLOSE.
END PROCEDURE.

PROCEDURE pi-executa-merge-msword:
/*------------------------------------------------------------------------------   
  Purpose: Executa integraá∆o com word para merge do arquivo de dados com layout                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   DEF INPUT PARAM p-tipo-etiqueta AS INTEGER   NO-UNDO.
   DEF INPUT PARAM p-data-source   AS CHARACTER NO-UNDO.

   DEF VAR h-merge AS HANDLE NO-UNDO.

   /* obtem os campos doc-word e imp-windows da etiqueta */
   FIND FIRST tipo-etiqueta
        WHERE tipo-etiqueta.tipo-etiq = p-tipo-etiqueta NO-LOCK NO-ERROR.
   
   RUN pi-obtem-campos-impressao (BUFFER tipo-etiqueta,
                                  OUTPUT i-tipo-destino,
                                  OUTPUT c-impres-ems,
                                  OUTPUT c-layout-ems,
                                  OUTPUT c-doc-msword,
                                  OUTPUT c-imp-windows).
   IF l-msword THEN DO:
      RUN utp/utapi020.p PERSISTENT SET h-merge.
   
      RUN iniciaMerge IN h-merge.
      IF RETURN-VALUE = "NOK":U THEN DO:
         RUN pi-processa-erros-merge (h-merge).
         RETURN.
      END.
   
      IF vg-teste-etiqueta THEN DO:
         RUN defineAcompanhamento IN h-merge (YES).
         RUN defineMostraErro IN h-merge (YES).
      END.
      ELSE DO:
         RUN defineAcompanhamento IN h-merge (NO).
         RUN defineMostraErro IN h-merge (NO).
      END.
      RUN salvaAutoCorrecao IN h-merge.
      RUN desligaAutoCorrecao IN h-merge.
   
      RUN defineDocumentoLayout IN h-merge (c-doc-msword).
      IF RETURN-VALUE = "NOK":U THEN DO:
         RUN pi-processa-erros-merge (h-merge).
         RETURN.
      END. 
   
      RUN defineDataSource IN h-merge (p-data-source).
      IF RETURN-VALUE = "NOK":U THEN DO:
          RUN pi-processa-erros-merge (h-merge).
          RETURN.
      END.
   
      RUN executaMerge IN h-merge.
      IF RETURN-VALUE = "NOK":U THEN DO:
          RUN pi-processa-erros-merge (h-merge).
          RETURN.
      END.
   END.

   IF l-libre THEN DO:
      EMPTY TEMP-TABLE tt-configuracao.
   
      CREATE tt-configuracao.       
      ASSIGN tt-configuracao.versao-integracao   = 1
             tt-configuracao.modelo              = c-doc-msword  /*arquivo que contem o layout a ser populado*/
             tt-configuracao.senha-modelo        = ""
             tt-configuracao.exibir-construcao   = YES
             tt-configuracao.imprimir            = NO.
   END.
   
   /* API utapi012 - atualiza indicadores(campos) no word */
   EMPTY TEMP-TABLE tt-epc.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event        = "SelectPrint":U
          tt-epc.cod-parameter    = "Print":U
          tt-epc.val-parameter    = c-imp-windows.

   IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
      IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
         RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

         IF i-Cloud = 1 THEN
            OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
         ELSE 
            OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
              
         {utp/ut-liter.i "SelectPrint" *}
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-antes-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 "Return-value:":U RETURN-VALUE.
         IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Error-Status" *}
            PUT UNFORMATTED "        (BCAPI007) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
         END.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
         FOR EACH tt-epc:
            PUT UNFORMATTED "        (BCAPI007) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.
            
            {utp/ut-liter.i "BCAPI007)_:cod-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.
            
            {utp/ut-liter.i "BCAPI007)_:val-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.
            
            {utp/ut-liter.i "BCAPI007" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
         END.
         OUTPUT CLOSE.   
      END.
   END.

   {include/i-epc201.i "SelectPrint"}

   IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
      IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
         RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

         IF i-Cloud = 1 THEN
              OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT  TARGET  "iso8859-1":U APPEND.
         ELSE 
              OUTPUT TO VALUE(c-arquivo-log) CONVERT  TARGET  "iso8859-1":U APPEND.

         {utp/ut-liter.i "SelectPrint" *}
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-depois-execucao-upc) RETURN-VALUE STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 "Return-value:":U RETURN-VALUE.
         IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Error-Status" *}
            PUT UNFORMATTED "        (BCAPI007) ":U AT 1  RETURN-VALUE + ":("  ERROR-STATUS:NUM-MESSAGES ")":U SUBSTRING(ERROR-STATUS:GET-MESSAGE(1),1,50) SKIP.
         END.
         PUT UNFORMATTED "        (BCAPI007) ":U AT 1 TRIM(c-registros-tt-epc) SKIP.
         FOR EACH tt-epc:
            PUT UNFORMATTED "        (BCAPI007) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.

            {utp/ut-liter.i "BCAPI007)_:cod-parameter" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.
            
            {utp/ut-liter.i "BCAPI007)_:val-parameter" *}               
            PUT UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.

            {utp/ut-liter.i "BCAPI007" *}
            PUT UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
         END.
         OUTPUT CLOSE.   
      END.
   END.

   FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = "SelectPrint":U
          AND tt-epc.cod-parameter = "Print":U NO-LOCK NO-ERROR.
   IF AVAIL tt-epc THEN
      ASSIGN c-imp-windows = tt-epc.val-parameter.

   IF l-msword THEN DO:   
      /* Se for teste de etiqueta deixa os arquivos abertos */
      IF vg-teste-etiqueta THEN DO:
         IF vg-geracao-word = "2":U THEN DO: /* impress∆o */
            IF c-imp-windows <> "":U THEN DO:
               RUN defineImpressora IN h-merge (c-imp-windows).
               IF RETURN-VALUE = "NOK":U THEN DO:
                  RUN pi-processa-erros-merge (h-merge).
                  RETURN.
               END.
            END.
            RUN imprimeMerge IN h-merge.
         END.
         RUN restauraAutoCorrecao IN h-merge.
         RUN encerraAutomation IN h-merge (NO).
      END.
      ELSE DO:
         IF c-imp-windows <> "":U THEN DO:
            RUN defineImpressora IN h-merge (c-imp-windows).
            IF RETURN-VALUE = "NOK":U THEN DO:
               RUN pi-processa-erros-merge (h-merge).
               RETURN.
            END.
         END.
         RUN imprimeMerge IN h-merge.
         RUN restauraAutoCorrecao IN h-merge.
         RUN fechaArquivos IN h-merge.
         RUN encerraAutomation IN h-merge (YES).
      END.
      DELETE PROCEDURE h-merge.   
   END.
      
   
   IF l-libre THEN DO:
      RUN utp/utapi027.p (INPUT-OUTPUT TABLE tt-configuracao,                                             
                          INPUT-OUTPUT TABLE tt-dados,                                                     
                          INPUT-OUTPUT TABLE tt-erros).
   END.
   
   EMPTY TEMP-TABLE tt-dados.
   EMPTY TEMP-TABLE tt-configuracao.
   
END PROCEDURE.

PROCEDURE pi-processa-erros-merge:
/*------------------------------------------------------------------------------   
  Purpose:                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   DEF INPUT PARAM h-merge     AS HANDLE NO-UNDO.

   RUN obtemErro IN h-merge (OUTPUT TABLE tt-erro).
   RUN restauraAutoCorrecao IN h-merge.
   DELETE PROCEDURE h-merge.
END PROCEDURE.

PROCEDURE pi-cria-tt-epc.
/*------------------------------------------------------------------------------   
  Purpose:                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/  
   EMPTY TEMP-TABLE tt-epc.

   ASSIGN i-etiq-tot = 0.

   FOR EACH b-tt-etiqueta-aux
      WHERE b-tt-etiqueta-aux.tipo-etiq = tt-etiqueta-aux.tipo-etiq:
      ASSIGN i-etiq-tot = i-etiq-tot + 1.
   END.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "i-etiq-tot":U
          tt-epc.val-parameter = STRING(i-etiq-tot).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "cd-trans":U
          tt-epc.val-parameter = tt-etiqueta-aux.cd-trans.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Quantidade":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.quantidade).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Nr-docto":U
          tt-epc.val-parameter = tt-etiqueta-aux.nr-docto.       

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Nr-Trans":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.nr-trans).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "It-Codigo":U
          tt-epc.val-parameter = tt-etiqueta-aux.it-codigo.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "I-Sequen":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.i-sequen).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Lote":U
          tt-epc.val-parameter = tt-etiqueta-aux.lote.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Deposito":U
          tt-epc.val-parameter = tt-etiqueta-aux.cod-depos.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Localizacao":U
          tt-epc.val-parameter = tt-etiqueta-aux.cod-localiz.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Estabelecimento":U
          tt-epc.val-parameter = tt-etiqueta-aux.cod-estabel.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "DtValidadeLote":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.dt-val-lote,"99/99/9999").

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "NatOperacao":U
          tt-epc.val-parameter = tt-etiqueta-aux.nat-operacao.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Serie":U
          tt-epc.val-parameter = tt-etiqueta-aux.serie-docto.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Emitente":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.cod-emitente).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Peso-bruto":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.peso-bruto).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Peso-liquido":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.peso-liquido).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-01":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-01.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-02":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-02.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-03":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-03.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-04":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-04.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-05":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-05.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-06":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-06.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-07":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-07.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-08":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-08.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-09":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-09.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-10":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-10.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-11":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-11.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-12":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-12.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-13":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-13.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-14":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-14.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-15":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-15.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-16":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-16.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-17":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-17.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-18":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-18.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-19":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-19.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Auxiliar-20":U
          tt-epc.val-parameter = tt-etiqueta-aux.auxiliar-20.

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "tipo-etiq":U
          tt-epc.val-parameter = STRING(tt-etiqueta-aux.tipo-etiq).

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "Cod-Referencia":U
          tt-epc.val-parameter = tt-etiqueta-aux.cod-referencia. 

   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Auxiliary-Field":U
          tt-epc.cod-parameter = "tt-etiqueta-handle":U
          tt-epc.val-parameter =  STRING(TEMP-TABLE tt-etiqueta-aux:HANDLE). 

END.

PROCEDURE pi-abrir-impressora:
/*------------------------------------------------------------------------------   
  Purpose:                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   FIND FIRST impressora OF imprsor_usuar NO-LOCK NO-ERROR.
   FIND FIRST tip_imprsor OF impressora NO-LOCK NO-ERROR.
   
   IF OPSYS <> "WIN32":U AND OPSYS <> "MSDOS":U THEN DO:
      IF layout_impres.num_lin_pag = 0 THEN /* sem salta p†gina */
         OUTPUT STREAM s-etiqueta THROUGH VALUE(imprsor_usuar.nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET tip_imprsor.cod_pag_carac_conver. 
      ELSE /* com salta p†gina */
         OUTPUT STREAM s-etiqueta THROUGH VALUE(imprsor_usuar.nom_disposit_so) PAGED PAGE-SIZE VALUE(layout_impres.num_lin_pag) CONVERT TARGET tip_imprsor.cod_pag_carac_conver.
   END.
   ELSE DO:
      IF layout_impres.num_lin_pag = 0 THEN /* sem salta p†gina */
         OUTPUT STREAM s-etiqueta TO VALUE(imprsor_usuar.nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET tip_imprsor.cod_pag_carac_conver. 
      ELSE /* com salta p†gina */
         OUTPUT STREAM s-etiqueta TO VALUE(imprsor_usuar.nom_disposit_so) PAGED PAGE-SIZE VALUE(layout_impres.num_lin_pag) CONVERT TARGET tip_imprsor.cod_pag_carac_conver.
   END.
   
   FOR EACH configur_layout_impres
      WHERE configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres NO-LOCK
         BY configur_layout_impres.num_ord_funcao_imprsor:
      
      FIND FIRST configur_tip_imprsor USE-INDEX cnfgrtpm_id 
           WHERE configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
             AND configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
             AND configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor NO-LOCK NO-ERROR.
      IF AVAIL configur_tip_imprsor THEN DO:
   	   DO v_num_count = 1 TO EXTENT(configur_tip_imprsor.num_carac_configur):
   	      CASE configur_tip_imprsor.num_carac_configur[v_num_count]:
   	         WHEN 0 THEN
   	            PUT STREAM s-etiqueta CONTROL NULL.
   	         WHEN ? THEN
   	            LEAVE.
   	         OTHERWISE
   	            PUT STREAM s-etiqueta CONTROL CODEPAGE-CONVERT(CHR(configur_tip_imprsor.num_carac_configur[v_num_count]),SESSION:CPINTERNAL,tip_imprsor.cod_pag_carac_conver).
   	      END CASE.
         END.
      END.
   END.
END PROCEDURE.

PROCEDURE pi-envia-layout-impressao:
/*------------------------------------------------------------------------------   
  Purpose: Se for etiqueta 1D e tiver layout de impress∆o, envia antes                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   DEFINE VARIABLE lReturnOK AS LOGICAL  INITIAL YES  NO-UNDO.

   IF NOT AVAIL tipo-etiqueta  THEN DO:
      FIND FIRST tipo-etiqueta
           WHERE tipo-etiqueta.tipo-etiq = tt-etiqueta-aux.tipo-etiq NO-LOCK NO-ERROR.
   END.

   /* Somente executa se a versao do ems for maior que 204 */
   /* Verifica se n∆o foi enviado para a impressora o layout */
   IF (tipo-etiqueta.cod-layout <> i-cod-layout)
      AND (i-cod-layout > 0)
      AND tipo-etiqueta.cod-layout <> 0
      AND tipo-etiqueta.ind-dimensao = 1 THEN DO:
      
      ASSIGN i-cod-layout = tipo-etiqueta.cod-layout.

      /* Gera o layout de etiqueta */
      CREATE tt-etiqueta-layout.
      ASSIGN tt-etiqueta-layout.cod-versao-integracao = 1
             tt-etiqueta-layout.i-sequen              = 1
             tt-etiqueta-layout.cd-trans              = tt-etiqueta-aux.cd-trans
             tt-etiqueta-layout.tipo-etiq             = tipo-etiqueta.cod-layout
             tt-etiqueta-layout.usuario               = tt-etiqueta-aux.usuario
             tt-etiqueta-layout.dt-impressao          = TODAY
             tt-etiqueta-layout.hora-impressao        = STRING(TIME,"HH:MM:SS")
             tt-etiqueta-layout.qt-etiqueta           = 1.

      /* Envia o layout para impressao */            
      RUN bcp/bcapi007.p (INPUT-OUTPUT TABLE tt-etiqueta-layout,
                          INPUT-OUTPUT TABLE tt-erro,
                          OUTPUT c-relacao-arquivos).
                          
      FIND FIRST tt-erro NO-ERROR.
      IF AVAIL tt-erro THEN
         ASSIGN lReturnOk = NO.
   END.
   IF lReturnOK THEN
      RETURN "OK":U.
   ELSE
      RETURN "NOK":U.
END PROCEDURE.

PROCEDURE pi-envia-erro-extratoversao:
/*------------------------------------------------------------------------------   
  Purpose: Se for etiqueta 1D e tiver layout de impress∆o, envia antes                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   DEF INPUT PARAM p_erro_extrato     AS CHARACTER NO-UNDO.

   IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
      RUN Valid_Param_Cloud (OUTPUT i-Cloud). 

      IF i-Cloud = 1 THEN
         OUTPUT TO PRINTER VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.
      ELSE 
         OUTPUT TO VALUE(c-arquivo-log) CONVERT TARGET "iso8859-1":U APPEND.

      {utp/ut-liter.i "ERRO_=>" *}
      PUT UNFORMATTED RETURN-VALUE + " " AT 1 TRIM(p_erro_extrato) SKIP.
      OUTPUT CLOSE.   
   END.
END PROCEDURE.
	
PROCEDURE Valid_Param_Cloud:
/*------------------------------------------------------------------------------   
  Purpose: Valida parametro Cloud                                                                         
  Parameters:  <none>                                                              
  Notes:                                                                           
------------------------------------------------------------------------------*/     
   DEFINE OUTPUT PARAMETER pCloud  AS INTEGER NO-UNDO.

   FIND FIRST param-bc NO-LOCK NO-ERROR.

   IF AVAIL param-bc THEN
      ASSIGN pCloud = param-bc.idi-cloud.
   ELSE
      ASSIGN pCloud = 0.
END PROCEDURE.
