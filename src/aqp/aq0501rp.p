/********************************************************************************
** Copyright DATASUL S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0501RP 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0501RP MAQ}
&ENDIF

{utp/ut-glob.i}
{aqp/aqapi001.i} /* Definicao da temp-table*/
{method/dbotterr.i} /* rowErrors*/

DEFINE VARIABLE h-aqapi001 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp    AS HANDLE NO-UNDO.

def var c-lb-impr         as char no-undo.
def var c-lb-dest         as char no-undo.
def var c-lb-usuar        as char no-undo.
def var c-lb-sel          as char no-undo.
def var c-lb-regiao       as char no-undo.
def var c-lb-rota         as char no-undo.
def var c-lb-grupo        as char no-undo.
def var c-lb-produtor     as char no-undo.
def var c-lb-propriedade  as char no-undo.
def var c-lb-pto-coleta   as char no-undo.
def var c-msg             as char no-undo.
def var c-lb-par          as char no-undo.
def var c-lb-estabel      as char no-undo.
def var c-lb-period       as char no-undo.
def var c-lb-item         as char no-undo.
def var c-nome-estabel    as char no-undo.
def var c-desc-item       as char no-undo.
def var c-lb-dig          as char no-undo.
def var c-lb-reg-conf     as char no-undo.
def var c-lb-reg-conf-v   as char no-undo.
def var c-lb-sob-bon-fx   as char no-undo.
def var c-lb-sob-bon-fx-v as char no-undo.



{include/i-rpvar.i}

def temp-table tt-raw-digita
   field raw-digita      as raw.    

{include/tt-edit.i}
   
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

find first param-global no-lock no-error.

find empresa where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

assign c-empresa   = (if avail param-global then param-global.grupo else "")
       c-programa  = "AQ0501".

{include/i-rpcab.i}

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

       
RUN aqp/aqapi001.p PERSISTENT SET h-aqapi001. 


RUN piGetPreco IN h-aqapi001 (INPUT  TABLE tt-param,
                              INPUT  TABLE tt-digita,
                              INPUT  "aq0501",
                              OUTPUT TABLE rowErrors).

/*=======================================================================================*/

form rowErrors.errorSequence    LABEL "Seq" FORMAT ">>>"
     rowErrors.errorDescription             FORMAT "X(122)"
         WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-erro. 

{utp/ut-liter.i Erros * r}
ASSIGN rowErrors.errorDescription:LABEL IN FRAME f-erro = RETURN-VALUE.
   

form tt-digita.cod-rota FORMAT "X(16)"
     tt-digita.des-rota FORMAT "X(115)"
         WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-digita.


{utp/ut-liter.i Apura‡Æo_de_valores_efetuada_com_sucesso! * r}
ASSIGN c-msg = TRIM(RETURN-VALUE).

PUT UNFORMATTED SKIP(1)
c-msg           SKIP(2).


/*erros*/
FOR EACH rowErrors:
    DISP rowErrors.errorSequence
         rowErrors.errorDescription       
             WITH FRAME f-erro.
        DOWN WITH FRAME f-erro.

END.
/*******/

/*Impressão parâmetros em tela*/
{utp/ut-liter.i SELE€ÇO * r}
assign c-lb-sel = trim(return-value).
{utp/ut-liter.i RegiÆo * r}
assign c-lb-regiao = trim(return-value).
{utp/ut-liter.i Rota * r}
assign c-lb-rota = trim(return-value).
{utp/ut-liter.i Grupo * r}
assign c-lb-grupo = trim(return-value).
{utp/ut-liter.i Produtor * r}
assign c-lb-produtor = trim(return-value).
{utp/ut-liter.i Propriedade * r}
assign c-lb-propriedade = trim(return-value).
{utp/ut-liter.i Ponto_Coleta * r}
assign c-lb-pto-coleta = trim(return-value).

{utp/ut-liter.i PAR¶METROS * r}
assign c-lb-par = trim(return-value).
{utp/ut-liter.i Estabelecimento * r}
assign c-lb-estabel = trim(return-value).
{utp/ut-liter.i Per¡odo * r}
assign c-lb-period = trim(return-value).
{utp/ut-liter.i Item * r}
assign c-lb-item = trim(return-value).
{utp/ut-liter.i Aplica_regras_pre‡o_confirmado * r}
assign c-lb-reg-conf = trim(return-value).
{utp/ut-liter.i Sobrepäe_B“nus_Fixo_Informado * r}
assign c-lb-sob-bon-fx = trim(return-value).

{utp/ut-liter.i DIGITA€ÇO * r}
assign c-lb-dig = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * r}
assign c-lb-impr = trim(return-value).
{utp/ut-liter.i Destino * r}
assign c-lb-dest = trim(return-value).
{utp/ut-liter.i Usu rio * r}
assign c-lb-usuar = trim(return-value).

FOR FIRST estabelec FIELDS(nome) NO-LOCK WHERE estabelec.cod-estabel = tt-param.cod-estabel-ini:
    ASSIGN c-nome-estabel = estabelec.nome.
END.

FOR FIRST item FIELDS(desc-item) NO-LOCK WHERE item.it-codigo = tt-param.it-codigo:
    ASSIGN c-desc-item = item.desc-item.
END.

IF tt-param.recalcula-sit-conf THEN DO:
    {utp/ut-liter.i Sim * r}
    assign c-lb-reg-conf-v = trim(return-value).
END.
ELSE DO:
    {utp/ut-liter.i NÆo * r}
    assign c-lb-reg-conf-v = trim(return-value).
END.

IF tt-param.sobrepoe-bon-fix-inf THEN DO:
    {utp/ut-liter.i Sim * r}
    assign c-lb-sob-bon-fx-v = trim(return-value).
END.
ELSE DO:
    {utp/ut-liter.i NÆo * r}
    assign c-lb-sob-bon-fx-v = trim(return-value).
END.

/*seleção*/
PUT UNFORMATTED SKIP(3)
    c-lb-sel                SKIP(1)
    c-lb-regiao             AT 5  ": " tt-param.cod-regiao-ini       AT 20 "|<  >| " AT 37 tt-param.cod-regiao-fim
    c-lb-rota               AT 5  ": " tt-param.cod-rota-ini         AT 20 "|<  >| " AT 37 tt-param.cod-rota-fim
    c-lb-grupo              AT 5  ": " tt-param.cdn-grp-produt-ini   AT 20 "|<  >| " AT 37 tt-param.cdn-grp-produt-fim
    c-lb-produtor           AT 5  ": " tt-param.cdn-produt-rural-ini AT 20 "|<  >| " AT 37 tt-param.cdn-produt-rural-fim
    c-lb-propriedade        AT 5  ": " tt-param.cod-propried-ini     AT 20 "|<  >| " AT 37 tt-param.cod-propried-fim
    c-lb-pto-coleta         AT 5  ": " tt-param.cod-pto-coleta-ini   AT 20 "|<  >| " AT 37 tt-param.cod-pto-coleta-fim.

/*parâmetros*/
PUT UNFORMATTED SKIP(1)
    c-lb-par               SKIP(1)
    c-lb-estabel            AT 5  ": " tt-param.cod-estabel-ini             AT 37 " " c-nome-estabel
    c-lb-period             AT 5  ": " tt-param.cod-period FORMAT "99/9999" AT 37
    c-lb-item               AT 5  ": " tt-param.it-codigo                   AT 37 " " c-desc-item
    c-lb-reg-conf           AT 5  ": " c-lb-reg-conf-v                      AT 37 " "
    c-lb-sob-bon-fx         AT 5  ": " c-lb-sob-bon-fx-v                    AT 37 " ".

/*digitação*/
IF CAN-FIND(FIRST tt-digita) THEN DO:
    PUT UNFORMATTED SKIP(1)
        c-lb-dig               SKIP(1).
    /*digitação*/
    FOR EACH tt-digita:
        DISP tt-digita.cod-rota
             tt-digita.des-rota
                 WITH FRAME f-digita.
            DOWN WITH FRAME f-digita.
    
    END.
    /***********/
END.

/*impressão*/
PUT UNFORMATTED SKIP(1)
    c-lb-impr               SKIP(1)
    c-lb-dest               AT 5  ": " tt-param.destino " - " tt-param.arquivo
    c-lb-usuar              AT 5  ": " tt-param.usuario SKIP(1).
/******************************/



{include/i-rpclo.i}

{include/pi-edit.i}

/*=======================================================================================*/


IF  h-acomp <> ? THEN DO:
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    
END.

IF  h-aqapi001 <> ? THEN DO:
    DELETE PROCEDURE h-aqapi001.
    ASSIGN h-aqapi001 = ?.    
END.



return "OK":U.
