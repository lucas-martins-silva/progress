/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0601RP 2.00.00.026 } /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0601RP MBC}
&ENDIF


{include/i_fnctrad.i}

{bcp/bc0204.i}

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

{cdp/cd0666.i}

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def stream s-imp.
def stream s-add-enter.

def var c-impressao     as char     format "x(09)"      no-undo.
def var c-destino       as char     format "x(10)"      no-undo.
def var c-parametros    as char     format "x(10)"      no-undo.
def var h-acomp         as handle                       no-undo.
def var c-arq-origem    as char                         no-undo.
def var c-arq-destino   as char                         no-undo.
def var c-linha         as char                         no-undo.
def var i-aux           as int                          no-undo.
def var i-arq-dest      as int      format "9999999999" no-undo.
def var l-elimina-arq   as log      initial no          no-undo.
def var c-delimitador   as char     format "X"          no-undo.
def var c-trans         as char                         no-undo.
def var c-erro          as char                         no-undo.
def var c-erro1         as char                         no-undo.
def var c-rpw-msg        as char                no-undo.
def var c-processo     as char.


create tt-param.
raw-transfer raw-param to tt-param.

assign tt-param.hr-ini = tt-param.hr-ini.

find first param-bc NO-LOCK NO-ERROR.

form
    c-linha format "x(130)"
    with stream-io width 132 frame f-linha.

{utp/ut-liter.i Linha * r}
assign c-linha:label in frame f-linha = return-value.

form 
    skip(2)
    c-impressao        no-label colon 45 
    skip(1)
    c-destino                   colon 60
    "-" tt-param.arq-destino    format "X(50)"   no-label
    tt-param.usuario            colon 60
    with stream-io down width 132 side-labels frame f-det.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Importando * r}
run pi-inicializar in h-acomp (input trim(return-value)).

{include/i-rpvar.i}

find first empresa
     where empresa.ep-codigo = tt-param.ep-codigo no-lock no-error.
if avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

{utp/ut-liter.i "Importa‡Æo de Transa‡äes" * L}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i Processo * L}
assign c-processo   = trim(return-value).

assign c-programa     = "BC00601"
       c-sistema      = "COLETA DE DADOS"
       c-versao       = "1.00"
       c-revisao      = "01".

/*** Definicao da temp-table tt-epc ***/
{include/i-epc200.i bc0601rp}


/***** UPC PARA INTEGRA€ÇO *****/

for each tt-epc:
    delete tt-epc.
end.

create  tt-epc.
assign  tt-epc.cod-event        = "Generation-File"
        tt-epc.cod-parameter    = "Colector-Initial"
        tt-epc.val-parameter    = tt-param.coletor-ini.

create  tt-epc.
assign  tt-epc.cod-event        = "Generation-File"
        tt-epc.cod-parameter    = "Colector-Finish"
        tt-epc.val-parameter    = tt-param.coletor-fim.

{include/i-epc201.i "Generation-File"}

/******************************/

run utp/ut-trfrrp.p (input frame f-det:handle).
run utp/ut-trfrrp.p (input frame f-linha:handle).
{include/i-rpcab.i}
{include/i-rpout.i &tofile=tt-param.arq-destino}

view frame f-cabec.
view frame f-rodape.

Find first Param-Bc no-lock no-error.
if  avail Param-Bc
then    assign  c-delimitador = trim(param-bc.char-1).
assign i-aux = 1.

{utp/ut-liter.i "Erros Ocorridos na Importa‡Æo" * r}
assign c-erro = trim(return-value).
{utp/ut-liter.i "NÆo encontrado arquivo a ser Importado" * r}
assign c-erro1 = trim(return-value).

for each bc-coletor no-lock
   where bc-coletor.ativo       = true
     and bc-coletor.id-coletor >= tt-param.coletor-ini
     and bc-coletor.id-coletor <= tt-param.coletor-fim:

    /*Ponto de chamada para Felters - Elisangela.*/

    RUN pi-limpa-return-value.

    for each tt-epc:
        delete tt-epc.
    end.

    create  tt-epc.
    assign  tt-epc.cod-event        = "Verify-Record"
            tt-epc.cod-parameter    = "Colector-Rowid"
            tt-epc.val-parameter    = STRING(ROWID(bc-coletor)).

    {include/i-epc201.i "Verify-Record"}

    IF  RETURN-VALUE <> "OK" AND 
        RETURN-VALUE <> ""  THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_UPC_Ponto_Colector-Rowid" *}
        Put unformatted "*** " + RETURN-VALUE + "***"
                        skip.
        PUT UNFORMATTED RETURN-VALUE SKIP(1).
    END.

    /*Fim Ponto de chamada para Felters - Elisangela.*/
    assign  i-arq-dest      = this-procedure
            c-arq-origem    = replace(bc-coletor.diretorio,"~\","/")
            c-arq-origem    = c-arq-origem + "/" + bc-coletor.nome-arq
            c-arq-destino   = replace(bc-coletor.diretorio,"~\","/")
            c-arq-destino   = c-arq-destino + "/" + substring(string(i-arq-dest,"9999999999"),3,8) + '.tmp'
            c-arq-origem    = replace(c-arq-origem  ,"//","/")
            c-arq-destino   = replace(c-arq-destino ,"//","/").

    if  search(c-arq-origem) = ?
    then do:
        Put unformatted "*** "
                        c-erro
                        "***"
                        skip(1).

        Put unformatted c-erro1
                        " (" + c-arq-origem +  ")"
                        skip.

        assign  c-rpw-msg = c-erro + CHR(13) + c-erro1 + " (" + c-arq-origem +  ")".
    end.
    else do:

        /* ABRE O ARQUIVO DE IMPORTA€ÇO E ACRESCENTA UM <ENTER> NO FINAL */
        ASSIGN FILE-INFO:FILE-NAME = c-arq-origem.
        if  index(file-info:file-type,'w') <> 0
        then do:
            output STREAM s-add-enter to value(file-info:pathname) append.
            put STREAM s-add-enter control chr(10).
            OUTPUT STREAM s-add-enter close.
        end /* if */.

        OS-Rename value(c-arq-origem) value(c-arq-destino).

        if  OS-Error = 10   /* Arquivo Destino ja existe    */
        then do:
            OS-Delete value(c-arq-destino).
            OS-Rename value(c-arq-origem) value(c-arq-destino).
        end.

        if  OS-Error <> 0 then Next.

        Run Pi-Importa.

        if  l-elimina-arq THEN DO:
            /*Ponto de chamada para Felters - Elisangela.*/

            RUN pi-limpa-return-value.

            for each tt-epc:
                delete tt-epc.
            end.

            create  tt-epc.
            assign  tt-epc.cod-event        = "Before-File-Delete"
                    tt-epc.cod-parameter    = "File-Name"
                    tt-epc.val-parameter    = c-arq-destino.

            {include/i-epc201.i "Before-File-Delete"}

            IF  RETURN-VALUE <> "OK" AND 
                RETURN-VALUE <> ""  THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Erro_UPC_Ponto_Before-File-Delete" *}
                Put unformatted "*** " + RETURN-VALUE + "***"
                                skip.
                PUT UNFORMATTED RETURN-VALUE SKIP(1).
            END.

            /*Fim Ponto de chamada para Felters - Elisangela.*/

            OS-Delete value(c-arq-destino).

            /*Ponto de chamada para Felters - Elisangela.*/

            RUN pi-limpa-return-value.

            for each tt-epc:
                delete tt-epc.
            end.

            create  tt-epc.
            assign  tt-epc.cod-event        = "After-File-Delete"
                    tt-epc.cod-parameter    = "Rowid-Colector"
                    tt-epc.val-parameter    = STRING(ROWID(bc-coletor)).

            {include/i-epc201.i "After-File-Delete"}

            IF  RETURN-VALUE <> "OK" AND 
                RETURN-VALUE <> ""  THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Erro_UPC_Ponto_After-File-Delete" *}
                Put unformatted "*** " + RETURN-VALUE + "***"
                                skip.
                PUT UNFORMATTED RETURN-VALUE SKIP(1).
            END.

            /*Fim Ponto de chamada para Felters - Elisangela.*/

        END.
        ELSE DO:

            OS-Rename value(c-arq-destino) value(c-arq-origem).

            /*Ponto de chamada para Felters - Elisangela.*/

            RUN pi-limpa-return-value.

            for each tt-epc:
                delete tt-epc.
            end.

            create  tt-epc.
            assign  tt-epc.cod-event        = "After-File-Rename"
                    tt-epc.cod-parameter    = "Colector-Rowid"
                    tt-epc.val-parameter    = STRING(ROWID(bc-coletor)).

            {include/i-epc201.i "After-File-Rename"}

            IF  RETURN-VALUE <> "OK" AND 
                RETURN-VALUE <> ""  THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Erro_UPC_Ponto_After-File-Rename" *}
                Put unformatted "*** " + RETURN-VALUE + "***"
                                skip.
                PUT UNFORMATTED RETURN-VALUE SKIP(1).
            END.

            /*Fim Ponto de chamada para Felters - Elisangela.*/
        END.
    end.

end.

{utp/ut-liter.i PAR¶METROS * r}
assign c-parametros = trim(return-value)
.
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 tt-param.destino}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino    = RETURN-VALUE.
&else
    ASSIGN c-destino    = {varinc/var00002.i 04 tt-param.destino}.
&endif

{utp/ut-liter.i IMPRESSÇO * r}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Usu rio * r}
assign tt-param.usuario:label in frame f-det = trim(return-value).
{utp/ut-liter.i Destino * r}
assign c-destino:label in frame f-det = trim(return-value).

disp c-impressao
     c-destino
     tt-param.arq-destino
     tt-param.usuario
     with frame f-det.

input stream s-imp close.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

if  c-rpw-msg <> "" 
then 
    return c-rpw-msg.
else
    return "OK".

/*=======================================================================================================================================*/
/*** PROCEDURE DE IMPORTA€ÇO ***/
procedure pi-importa:
    input stream s-imp from value(c-arq-destino).
    repeat:
        for each tt-erro:
            delete tt-erro.
        end.

        IMPORT STREAM s-imp UNFORMATTED c-linha.

        if c-linha = "" THEN NEXT.

        /* BEG UPC PARA INTEGRACAO */
        RUN pi-limpa-return-value.

        for each tt-epc:
            delete tt-epc.
        end.

        create  tt-epc.
        assign  tt-epc.cod-event        = "Line-Import"
                tt-epc.cod-parameter    = "Line-value"
                tt-epc.val-parameter    = c-linha.
        {include/i-epc201.i "Line-Import"}

        IF  RETURN-VALUE = "NOK" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-erros-ocorridos-na-importacao AS CHARACTER FORMAT "X(39)" NO-UNDO.
            {utp/ut-liter.i "Erros_Ocorridos_na_Importa‡Æo" *}
            ASSIGN c-lbl-liter-erros-ocorridos-na-importacao = TRIM(RETURN-VALUE).
            Put "*** " + c-lbl-liter-erros-ocorridos-na-importacao + " ***"
                skip(1).
            Put unformatted Trim(Return-Value)
                skip(1).
            NEXT.
        END.
        /* END UPC PARA INTEGRACAO */

        Assign  c-trans = Entry(1,c-linha,c-delimitador) no-error.

        If c-delimitador <> "" 
        and index(c-linha,c-delimitador) = 0        
        Then Do:
            Run utp/ut-msgs.p ( Input "help",
                                Input 25359,
                                Input c-delimitador).

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-erros-ocorridos-na-importacao-2 AS CHARACTER FORMAT "X(39)" NO-UNDO.
            {utp/ut-liter.i "Erros_Ocorridos_na_Importa‡Æo" *}
            ASSIGN c-lbl-liter-erros-ocorridos-na-importacao-2 = TRIM(RETURN-VALUE).
            Put "*** " + c-lbl-liter-erros-ocorridos-na-importacao-2 + " ***"
                skip(1).

            Put unformatted Trim(Return-Value)
                skip.

            assign  c-rpw-msg = c-rpw-msg + CHR(13) + trim(Return-Value).

            Next.
        End.

        find first bc-tipo-trans
             where bc-tipo-trans.cd-trans = Entry(1,c-linha,c-delimitador)
             no-lock no-error.

        if  not available bc-tipo-trans then
            find first bc-tipo-trans
                 where bc-tipo-trans.cd-trans = substring(c-linha,1,8)
                 no-lock no-error.

        if  not available(bc-tipo-trans)
        then do:
            {utp/ut-table.i mgcld bc-tipo-trans 1}
            Run utp/ut-msgs.p ( Input "msg",
                                Input 56,
                                Input return-value).

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-erros-ocorridos-na-importacao-3 AS CHARACTER FORMAT "X(39)" NO-UNDO.
            {utp/ut-liter.i "Erros_Ocorridos_na_Importa‡Æo" *}
            ASSIGN c-lbl-liter-erros-ocorridos-na-importacao-3 = TRIM(RETURN-VALUE).
            Put "*** " + c-lbl-liter-erros-ocorridos-na-importacao-3 + " ***"
                skip(1).

            Put unformatted Trim(Return-Value)
                skip.

            assign  c-rpw-msg = c-rpw-msg + CHR(13) + trim(Return-Value).

            Next.
        end.

        if  bc-tipo-trans.prog-import = ""
        then do:
            {utp/ut-liter.i "Importa‡Æo" * R}
            Run utp/ut-msgs.p ( Input "show",
                                Input 25358,
                                Input trim(return-value)).

            next.
        end.

        blk_import:
        DO  ON ERROR    undo blk_import, leave blk_import
            ON QUIT     undo blk_import, leave blk_import
            ON STOP     undo blk_import, leave blk_import
            ON ENDKEY   undo blk_import, leave blk_import:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Iniciando___processo_de_Importa‡Æo" *}
            put unformatted
                RETURN-VALUE + ". (" bc-tipo-trans.prog-import ")"
                skip.

            run value(bc-tipo-trans.prog-import) (input  rowid(bc-coletor),
                                                  input  c-linha,
                                                  output table tt-erro).
            if  Return-Value = "OK"
            then    assign l-elimina-arq = yes.

            run pi-acompanhar in h-acomp (input string(i-aux,"zzzzzzzzz9")).
            assign i-aux = i-aux + 1.

            find first tt-erro no-error.

            if  not available(tt-erro)
            AND tt-param.todos = 1
            then
                /* Inicio -- Projeto Internacional */
                DO:
                {utp/ut-liter.i "Processo_de_Importa‡Æo_feito_com_Sucesso" *}
                put unformatted
                    RETURN-VALUE + "."
                    skip.
                END. 

            if  AVAILABLE(tt-erro)
            OR tt-param.todos = 1
            then do:
                if  available(tt-erro)
                then    put unformatted
                        "*** "  c-erro "***"
                        skip(1).

                {utp/ut-liter.i Erros_na_Atualiza‡Æo * r}
                assign  c-rpw-msg = return-value + " ---> ".
                for each tt-erro:
                    put tt-erro.i-sequen
                        space(03)
                        tt-erro.cd-erro
                        space(03)
                        tt-erro.mensagem
                        skip.

                    assign  c-rpw-msg = c-rpw-msg + IF  LENGTH(c-rpw-msg) < 4000
                                                    then "*** " + bc-tipo-trans.cd-trans
                                                                + " "
                                                                + STRING(tt-erro.cd-erro)
                                                                + " - "
                                                                + tt-erro.mensagem
                                                                + CHR(13)
                                                    else "".
                end.
                if  return-value + " ---> " = c-rpw-msg then assign c-rpw-msg = "".

                disp c-linha with frame f-linha.
                put skip(1).
                down with frame f-linha.
            end.

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Finalizando_processo_de_Importa‡Æo" *}
            put unformatted
                RETURN-VALUE + ". (" bc-tipo-trans.prog-import ")"
                skip.
        end.
    end.
    input stream s-imp close.
end.

PROCEDURE pi-limpa-return-value:
    RETURN "".
END PROCEDURE.

return "OK".
