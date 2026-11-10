/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0119RP 2.00.00.014 } /*** "010014" 29/05/2026 09:54:00  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc0119rp MBC}
&ENDIF
/*************************************************************************
**
**     Programa BC0119RP.P
**
**************************************************************************/
DEF VAR da-data            AS DATE                 NO-UNDO.
DEF VAR cProcesso          AS CHAR                 NO-UNDO.
DEF VAR cTransLabel        AS CHAR                 NO-UNDO.
DEF VAR v_data             AS DATE                 NO-UNDO.
DEF VAR v_data_ini         AS DATE                 NO-UNDO.
DEF VAR v_data_fim         AS DATE                 NO-UNDO.
DEF VAR h-acomp            AS HANDLE               NO-UNDO.
DEF VAR i-cont             AS INT                  NO-UNDO.
DEF VAR i-seq              AS INT  initial 0       NO-UNDO.
DEF VAR c-lit-selecao      AS CHAR format "x(07)"  NO-UNDO.  
DEF VAR c-lit-impressao    AS CHAR format "x(09)"  NO-UNDO.  
DEF VAR c-lit-trans        AS CHAR format "x(60)"  NO-UNDO.  
DEF VAR c-trans            AS CHAR format "x(60)"  NO-UNDO.  
DEF VAR c-destino          AS CHAR format "x(10)"  NO-UNDO.  
DEF VAR c-tipo-trans       AS CHAR format "x(15)"  NO-UNDO.  
DEF VAR c-movimento        AS CHAR format "x(15)"  NO-UNDO.  
DEF VAR c-etiqueta         AS CHAR format "x(15)"  NO-UNDO.  
DEF VAR c-estado-trans     AS CHAR format "x(15)"  NO-UNDO.  
DEF VAR c-nova             AS CHAR format "x(15)"  NO-UNDO.  
DEF VAR c-atualizada       AS CHAR format "x(15)"  NO-UNDO.  
DEF VAR c-erro             AS CHAR format "x(15)"  NO-UNDO.  
DEF VAR c-lit-erros        AS CHAR format "x(10)"  NO-UNDO.  
DEF VAR c-linha            AS CHAR format "x(122)" NO-UNDO.  
DEF VAR c-linha1           AS CHAR format "x(122)" NO-UNDO.  

DEFINE NEW GLOBAL SHARED VAR v_cod_grp_usuar_lst AS CHARACTER FORMAT "x(3)":U LABEL "Grupo Usu rios"  COLUMN-LABEL "Grupo" NO-UNDO.

/*** DefiniîÒo da temp-table de erros ***/
{cdp/cd0666.i}

/*** DefiniîÒo das temp-tables para a API de criaîÒo de transaîÒo do CLD tt-trans***/
{bcp/bcapi001.i}

/*** DefiniîÒo da temp-table para a API de criaîÒo de etiquetas tt-reporte-bc ***/
{bcp/bc9006.i}

/*** variaveis globais ***/
{utp/ut-glob.i}
{include~/i_dbvers.i}

DEFINE TEMP-TABLE tt-param NO-UNDO
     FIELD destino          AS INTEGER
     FIELD arquivo          AS CHAR format "x(35)"            
     FIELD usuario          AS CHAR format "x(12)"
     FIELD data-exec        AS DATE
     FIELD hora-exec        AS INTEGER
     FIELD classifica       AS INTEGER
     FIELD desc-classifica  AS CHAR FORMAT "x(40)"
     FIELD dt-ini           AS DATE
     FIELD dt-fim           AS DATE
     FIELD it-codigo-ini    LIKE bc-etiqueta.it-codigo
     FIELD it-codigo-fim    LIKE bc-etiqueta.it-codigo
     FIELD hr-ini           AS CHAR
     FIELD hr-fim           AS CHAR
     FIELD estabel-ini      LIKE bc-etiqueta.cod-estabel
     FIELD estabel-fim      LIKE bc-etiqueta.cod-estabel 
     &IF "{&mguni_version}" >= "2.071" &THEN
         FIELD ep-codigo    LIKE empresa.ep-codigo
     &ELSE
         FIELD ep-codigo    AS INT
     &ENDIF
     FIELD tp-relatorio     AS INT 
     FIELD dt-criacao-ini   LIKE bc-etiqueta.dt-criacao
     FIELD dt-criacao-fim   LIKE bc-etiqueta.dt-criacao 
     FIELD hr-criacao-ini   LIKE bc-etiqueta.hr-criacao
     FIELD hr-criacao-fim   LIKE bc-etiqueta.hr-criacao 
     FIELD estado-ini       LIKE bc-etiqueta.cod-estado
     FIELD estado-fim       LIKE bc-etiqueta.cod-estado
     FIELD nr-etiq-ini      LIKE bc-etiqueta.nr-etiq
     FIELD nr-etiq-fim      LIKE bc-etiqueta.nr-etiq
     FIELD progressivo-ini  LIKE bc-etiqueta.progressivo
     FIELD progressivo-fim  LIKE bc-etiqueta.progressivo
     FIELD layout-ini       LIKE bc-etiqueta.cod-layout
     FIELD layout-fim       LIKE bc-etiqueta.cod-layout
     FIELD versao-ini       LIKE bc-etiqueta.num-versao
     FIELD versao-fim       LIKE bc-etiqueta.num-versao
     FIELD datasul-ini      LIKE bc-etiqueta.log-datasul
     FIELD datasul-fim      LIKE bc-etiqueta.log-datasul
     FIELD transacao        AS LOG.  

DEF new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
DEF new global shared var v_cdn_empres_usuar   like empresa.ep-codigo no-undo.

define temp-table tt-raw-digita
    field raw-digita    as raw.

def input param r-raw as raw no-undo.
def input param table for tt-raw-digita.
CREATE tt-param.
RAW-TRANSFER r-raw TO tt-param.

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Progressivos * C}
run pi-inicializar in h-acomp (input TRIM(RETURN-VALUE)).

{include/i-rpvar.i}

assign i-ep-codigo-usuario = tt-param.ep-codigo
       v_cdn_empres_usuar  = i-ep-codigo-usuario.

find first empresa no-lock
     where empresa.ep-codigo = i-ep-codigo-usuario no-error.

if  avail empresa
then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".


{utp/ut-liter.i Relat¢rio_de_Etiquetas_Eliminadas * C}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i Coleta_de_Dados * C}
assign c-sistema  = trim(return-value).
{include/i-rpcab.i}
{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.
view frame f-cab-tra.

IF tt-param.transacao = YES THEN DO: /* Atualiza automaticamente */

    {utp/ut-liter.i Estado: * C}
    ASSIGN cProcesso = TRIM(RETURN-VALUE).
    ASSIGN i-cont = 0.

     FOR EACH  bc-estado-etiq USE-INDEX ch-cod-estado
         WHERE bc-estado-etiq.cod-estado >= tt-param.estado-ini
         AND   bc-estado-etiq.cod-estado <= tt-param.estado-fim
         AND   bc-estado-etiq.eliminar-aut = YES NO-LOCK:

         FOR EACH  bc-etiqueta USE-INDEX ch-cod-estado
             WHERE bc-etiqueta.cod-estado =  bc-estado-etiq.cod-estado EXCLUSIVE-LOCK:
            
             ASSIGN da-data = TODAY - bc-estado-etiq.nr-dia-eliminar.
            
             IF CAN-FIND(FIRST bc-trans-etiq
                         WHERE bc-trans-etiq.nr-etiq  = bc-etiqueta.nr-etiq
                           AND bc-trans-etiq.data    >= da-data) THEN DO:
                 NEXT.
             END.

             ASSIGN i-cont = i-cont + 1.

             IF i-cont MOD 1000 = 0 THEN
                 RUN pi-acompanhar IN h-acomp (INPUT cProcesso + " " + STRING(bc-etiqueta.nr-etiq)). 
             
             FOR EACH bc-trans-filho-etiq FIELDS(nr-trans nr-etiq) USE-INDEX bctrnsfa-02 
                  WHERE bc-trans-filho-etiq.nr-etiq  = bc-etiqueta.nr-etiq EXCLUSIVE-LOCK:
                     DELETE bc-trans-filho-etiq.            
             END.

             FOR EACH bc-trans-etiq FIELDS(nr-etiq) 
                WHERE bc-trans-etiq.nr-etiq  = bc-etiqueta.nr-etiq EXCLUSIVE-LOCK:
                     DELETE bc-trans-etiq.
             END.
             DELETE bc-etiqueta.
         END.
     END.
END.
ELSE DO:
   
    {utp/ut-liter.i Etiqueta: * C}
    ASSIGN cprocesso = trim(RETURN-VALUE).
    {utp/ut-liter.i Movimento: * C}
    ASSIGN cTransLabel = TRIM(RETURN-VALUE).

    ASSIGN i-cont = 0.

    FOR EACH  bc-estado-etiq FIELDS(per-eliminar gr-usuar-elim cod-estado) USE-INDEX ch-cod-estado
        WHERE bc-estado-etiq.cod-estado >= tt-param.estado-ini
        AND   bc-estado-etiq.cod-estado <= tt-param.estado-fim
        AND   bc-estado-etiq.per-eliminar = YES                                
        AND   lookup(bc-estado-etiq.gr-usuar-elim,v_cod_grp_usuar_lst) <> 0 NO-LOCK:

        FOR EACH bc-etiqueta FIELDS(nr-etiq)
           WHERE bc-etiqueta.cod-estado  =  bc-estado-etiq.cod-estado
             AND bc-etiqueta.nr-etiq     >= tt-param.nr-etiq-ini  
             AND bc-etiqueta.nr-etiq     <= tt-param.nr-etiq-fim
             AND bc-etiqueta.cod-layout  >= tt-param.layout-ini  
             AND bc-etiqueta.cod-layout  <= tt-param.layout-fim  
             AND bc-etiqueta.num-versao  >= tt-param.versao-ini    
             AND bc-etiqueta.num-versao  <= tt-param.versao-fim  
             AND bc-etiqueta.log-datasul >= tt-param.datasul-ini    
             AND bc-etiqueta.log-datasul <= tt-param.datasul-fim   
             AND bc-etiqueta.cod-estabel >= tt-param.estabel-ini      
             AND bc-etiqueta.cod-estabel <= tt-param.estabel-fim    
             AND bc-etiqueta.it-codigo   >= tt-param.it-codigo-ini
             AND bc-etiqueta.it-codigo   <= tt-param.it-codigo-fim
             AND bc-etiqueta.progressivo >= tt-param.progressivo-ini
             AND bc-etiqueta.progressivo <= tt-param.progressivo-fim
             AND bc-etiqueta.dt-criacao  >= tt-param.dt-criacao-ini        
             AND bc-etiqueta.dt-criacao  <= tt-param.dt-criacao-fim   
             AND bc-etiqueta.hr-criacao  >= tt-param.hr-criacao-ini
             AND bc-etiqueta.hr-criacao  <= tt-param.hr-criacao-fim EXCLUSIVE-LOCK: 

                 ASSIGN i-cont = i-cont + 1.

                 IF i-cont MOD 1000 = 0 THEN
                    RUN pi-acompanhar IN h-acomp (INPUT cProcesso + " " + STRING(bc-etiqueta.nr-etiq)). 
               
                 FOR EACH bc-trans-filho-etiq FIELDS(nr-etiq nr-trans) USE-INDEX bctrnsfa-02 
                    WHERE bc-trans-filho-etiq.nr-etiq = bc-etiqueta.nr-etiq EXCLUSIVE-LOCK:
                      DELETE bc-trans-filho-etiq.            
                 END.

                 FOR EACH bc-trans-etiq FIELDS(nr-etiq nr-trans) 
                    WHERE bc-trans-etiq.nr-etiq = bc-etiqueta.nr-etiq EXCLUSIVE-LOCK:
                      DELETE bc-trans-etiq.
                 END.

                 DELETE bc-etiqueta.
        END.
    END.
END.

{utp/ut-liter.i NUMERO_DE_ETIQUETAS_ELIMINADAS * C}
PUT UNFORMATTED SKIP  RETURN-VALUE + ": " + STRING(i-cont)   SKIP.

RUN pi-finalizar in h-acomp.

IF  VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.

assign c-destino = {varinc/var00002.i 04 tt-param.destino}.

{include/i-rpclo.i}

return "OK".

