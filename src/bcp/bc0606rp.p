/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0606RP 2.00.00.005 }

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0606RP MBC}
&ENDIF

{bcp/bc0606.i}
{method/dbotterr.i}

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def stream s-imp.
def stream s-add-enter.

def var c-linha         as char                         no-undo.
def var c-impressao     as char     format "x(09)"      no-undo.
def var c-destino       as char     format "x(10)"      no-undo.
def var c-arquivo       as char     format "x(10)"      no-undo.
def var h-acomp         as handle                       no-undo.
//def var c-delimitador   as char     format "X"          no-undo.
def var i-aux           as int                          no-undo.
def var c-parametros    as char     format "x(10)"      no-undo.
def var c-processo      as char     format "x(10)"      no-undo.

DEFINE VARIABLE h-rfidapi001                AS HANDLE       NO-UNDO.
DEFINE VARIABLE tgRFIDAtivo                 AS LOGICAL      NO-UNDO.
DEFINE VARIABLE tgRFIDLogCriaFicha          AS LOGICAL      NO-UNDO.
DEFINE VARIABLE tgRFIDLogCriaIntegrRfid     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE deCodEPCTotvs               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE h-epcRepository AS HANDLE      NO-UNDO.
DEFINE VARIABLE pTagRfid AS CHARACTER   NO-UNDO.

/*
def var c-arq-origem    as char                         no-undo.
def var c-arq-destino   as char                         no-undo.
def var i-arq-dest      as int      format "9999999999" no-undo.
def var l-elimina-arq   as log      initial no          no-undo.
def var c-trans         as char                         no-undo.
def var c-erro          as char                         no-undo.
def var c-erro1         as char                         no-undo.
def var c-rpw-msg        as char                no-undo.
def var c-processo     as char.
*/

create tt-param.
raw-transfer raw-param to tt-param.

form
    c-linha format "x(130)"
    with stream-io width 132 frame f-linha.

{utp/ut-liter.i Linha * r}
assign c-linha:label in frame f-linha = return-value.

form 
    skip(2)
    c-impressao        no-label colon 45 
    skip(1)
    c-destino                   colon 30
    "-" tt-param.arq-destino    format "X(50)"   no-label
    tt-param.usuario            colon 30
    tt-param.cArquivo           format "X(70)"   colon 30
    c-processo                  colon 30
    with stream-io down width 132 side-labels frame f-det.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Importando * r}
run pi-inicializar in h-acomp (input trim(return-value)).

{include/i-rpvar.i}

find first mguni.empresa
     where empresa.ep-codigo = tt-param.ep-codigo no-lock no-error.
if avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

{utp/ut-liter.i "Exporta‡Æo/Importa‡Æo ExtensÆo Item" * L}
assign c-titulo-relat = trim(return-value).

assign c-programa     = "BC00606"
       c-sistema      = "COLETA DE DADOS"
       c-versao       = "1.00"
       c-revisao      = "01".

{include/i-rpcab.i}
{include/i-rpout.i &tofile=tt-param.arq-destino}

view frame f-cabec.
view frame f-rodape.

IF tt-param.rsProcesso = 1 //EXPORTACAO
THEN DO:
    OUTPUT stream s-imp TO VALUE(tt-param.cArquivo).

    //-> Inserir cabe‡alho no arquivo de importa‡Æo e validar se a exporta‡Æo tem cabe‡alho.
    PUT stream s-imp UNFORMATTED
            "C¢digo do Item;Item Externo 1;Item Externo 2;Item Externo 3;Item Externo 4;Fator Quantidade Etiqueta;Fator Quantiade Total;Imprime Etiqueta;Tipo Etiqueta;Tipo Etiqueta Total;Prefixo EPC TOTVS;Utiliza GTIN?;C¢digo GTIN;GS1 Company Prefix GTIN;Tag Size;Filter Value"
            SKIP.


    FOR  EACH bc-ext-item NO-LOCK
        WHERE bc-ext-item.it-codigo >= tt-param.codItemIni
          AND bc-ext-item.it-codigo <= tt-param.codItemFim
        :
        PUT stream s-imp UNFORMATTED
                bc-ext-item.it-codigo
                ";"
                bc-ext-item.it-codigo-ext-1
                ";"
                bc-ext-item.it-codigo-ext-2
                ";"
                bc-ext-item.it-codigo-ext-3
                ";"
                bc-ext-item.it-codigo-ext-4
                ";"
                bc-ext-item.qt-etiq-item
                ";"
                bc-ext-item.qt-etiq-total
                ";"
                IF bc-ext-item.imprime-etiq THEN "Sim" ELSE "NÆo"
                ";"
                bc-ext-item.tipo-etiq
                ";"
                bc-ext-item.tipo-etiq-total
                ";"
                bc-ext-item.cod-integr-rfid
                ";"
                IF bc-ext-item.log-utiliza-gtin THEN "Sim" ELSE "NÆo"
                ";"
                bc-ext-item.cod-gtin
                ";"
                bc-ext-item.num-company-prefix-size
                ";"
                bc-ext-item.num-tag-size
                ";"
                bc-ext-item.num-filter-value
                SKIP.

    END.
    OUTPUT stream s-imp CLOSE.
END.
ELSE DO:  //IMPORTACAO
    RUN rfid/repository/epcRepository.p PERSISTENT SET h-epcRepository.
    RUN rfid/rfidapi001.p       PERSISTENT SET h-rfidapi001.
    RUN pRFIDGetParam IN h-rfidapi001(OUTPUT tgRFIDAtivo,
                                      OUTPUT tgRFIDLogCriaFicha,
                                      OUTPUT tgRFIDLogCriaIntegrRfid).

    IF SEARCH(tt-param.cArquivo) <> ?
    THEN DO:
        INPUT STREAM s-imp FROM VALUE(tt-param.cArquivo).
        blkImport:
        repeat:
            IMPORT STREAM s-imp UNFORMATTED c-linha.
        
            if c-linha = "" THEN NEXT.
        
            IF INDEX(c-linha,";") = 0
            THEN DO:
                Run utp/ut-msgs.p ( Input "help",
                                    Input 25359,
                                    Input ";").
        
                Put unformatted Trim(Return-Value)
                    skip.
        
                LEAVE blkImport.
            End.
            //Ignorar Cabeçalho
            IF ENTRY(1,c-linha,";") = "C¢digo do Item" THEN NEXT.

            run pi-acompanhar in h-acomp (input string(i-aux,"zzzzzzzzz9")).
            assign i-aux = i-aux + 1.
        
            IF NOT CAN-FIND(FIRST ITEM
                            WHERE ITEM.it-codigo = trim(ENTRY(1,c-linha,";")))
            THEN DO:
                {utp/ut-table.i mgind item 1}
                Run utp/ut-msgs.p ( Input "msg",
                                    Input 56,
                                    Input RETURN-VALUE).
        
                PUT UNFORMATTED TRIM(RETURN-VALUE)
                    SKIP
                    "Linha:" i-aux " - "  c-linha
                    skip.
                NEXT.
            END.
            
            IF CAN-FIND(FIRST bc-ext-item
                        WHERE bc-ext-item.it-codigo = trim(ENTRY(1,c-linha,";")))
            THEN DO:
                {utp/ut-table.i mgcld bc-ext-item 1}
                Run utp/ut-msgs.p ( Input "msg",
                                    Input 1,
                                    Input RETURN-VALUE).
        
                PUT UNFORMATTED TRIM(RETURN-VALUE)
                    SKIP
                    "Linha:" i-aux " - "  c-linha
                    skip.
                NEXT.
            END.
        
            IF int(entry(09,c-linha,";")) > 0
            THEN DO:
                IF NOT CAN-FIND(FIRST tipo-etiqueta
                                WHERE tipo-etiqueta.tipo-etiq = int(entry(09,c-linha,";")))
                THEN DO:
                    {utp/ut-table.i mgcld tipo-etiqueta 1}
                    Run utp/ut-msgs.p ( Input "msg",
                                        Input 56,
                                        Input RETURN-VALUE).
        
                    PUT UNFORMATTED TRIM(RETURN-VALUE)
                        SKIP
                        "Linha:" i-aux " - "  c-linha
                        skip.
                    NEXT.
                END.
            END.
            IF int(entry(10,c-linha,";")) > 0
            THEN DO:
                IF NOT CAN-FIND(FIRST tipo-etiqueta
                                WHERE tipo-etiqueta.tipo-etiq = int(entry(10,c-linha,";")))
                THEN DO:
                    {utp/ut-table.i mgcld tipo-etiqueta 1}
                    Run utp/ut-msgs.p ( Input "msg",
                                        Input 56,
                                        Input RETURN-VALUE).
        
                    PUT UNFORMATTED TRIM(RETURN-VALUE)
                        SKIP
                        "Linha:" i-aux " - "  c-linha
                        skip.
                    NEXT.
                END.
            END.
    
            IF  tgRFIDAtivo
            AND (ENTRY(12,c-linha,";") = "Sim") //Utiliza GTIN
            AND CAN-FIND(FIRST bc-ext-item
                         WHERE bc-ext-item.it-codigo <> trim(ENTRY(01,c-linha,";"))
                           AND bc-ext-item.cod-gtin  = string(dec(entry(13,c-linha,";"))))
            THEN DO:
                {utp/ut-liter.i "C¢digo GTIN j  utilizado no item"}
                RUN utp/ut-msgs.p (INPUT "MSG",
                                   INPUT 17006,
                                   INPUT RETURN-VALUE + ":" + trim(ENTRY(01,c-linha,";")) + "~~" + RETURN-VALUE + ":" + trim(ENTRY(01,c-linha,";"))).
    
                PUT UNFORMATTED TRIM(RETURN-VALUE)
                    SKIP
                    "Linha:" i-aux " - "  c-linha
                    skip.
                NEXT.
            END.
    
            ASSIGN deCodEPCTotvs = DEC(ENTRY(11,c-linha,";")).

            IF  deCodEPCTotvs <> 0
            AND CAN-FIND(FIRST bc-ext-item
                         WHERE bc-ext-item.it-codigo <> trim(ENTRY(01,c-linha,";"))
                           AND bc-ext-item.cod-integr-rfid = deCodEPCTotvs)
            THEN DO:
                run utp/ut-msgs.p ( INPUT "msg":U,
                                    INPUT 55066,
                                    INPUT "").
    
                PUT UNFORMATTED TRIM(RETURN-VALUE) + ":" + STRING(deCodEPCTotvs)
                    SKIP
                    "Linha:" i-aux " - "  c-linha
                    skip.
                NEXT.
            END.

            IF  deCodEPCTotvs = 0
            AND tgRFIDAtivo
            AND tgRFIDLogCriaIntegrRfid
            THEN DO:
                //-> Validar se o c¢digo integra‡Æo esta autom tico, caso contr rio utilizar o que veio no arquivo.
                REPEAT:
                    RUN pRFIDGetCodIntegracao IN h-rfidapi001(  OUTPUT deCodEPCTotvs).
                    IF NOT CAN-FIND(FIRST bc-ext-item
                                    WHERE bc-ext-item.it-codigo <> trim(ENTRY(01,c-linha,";"))
                                      AND bc-ext-item.cod-integr-rfid = deCodEPCTotvs)
                    THEN LEAVE.
                END.
            END.

            CREATE  bc-ext-item.
            ASSIGN  bc-ext-item.it-codigo               = trim(entry(01,c-linha,";"))
                    bc-ext-item.it-codigo-ext-1         = entry(02,c-linha,";")
                    bc-ext-item.it-codigo-ext-2         = entry(03,c-linha,";")
                    bc-ext-item.it-codigo-ext-3         = entry(04,c-linha,";")
                    bc-ext-item.it-codigo-ext-4         = entry(05,c-linha,";")
                    bc-ext-item.imprime-etiq            = (entry(08,c-linha,";") =  "Sim")
                    bc-ext-item.qt-etiq-item            = IF bc-ext-item.imprime-etiq THEN dec(entry(06,c-linha,";")) ELSE 0
                    bc-ext-item.qt-etiq-total           = IF bc-ext-item.imprime-etiq THEN dec(entry(07,c-linha,";")) ELSE 0
                    bc-ext-item.tipo-etiq               = int(entry(09,c-linha,";"))
                    bc-ext-item.tipo-etiq-total         = int(entry(10,c-linha,";"))
                    bc-ext-item.cod-integr-rfid         = deCodEPCTotvs
                    bc-ext-item.log-utiliza-gtin        = (entry(12,c-linha,";") = "Sim")
                    bc-ext-item.cod-gtin                = IF bc-ext-item.log-utiliza-gtin THEN string(dec(entry(13,c-linha,";"))) ELSE ""
                    bc-ext-item.num-company-prefix-size = IF bc-ext-item.log-utiliza-gtin THEN int(entry(14,c-linha,";")) ELSE 0
                    bc-ext-item.num-tag-size            = IF bc-ext-item.log-utiliza-gtin THEN 96 ELSE 0
                    bc-ext-item.num-filter-value        = IF bc-ext-item.log-utiliza-gtin THEN INT(ENTRY(16,c-linha,";")) ELSE 9
                    bc-ext-item.val-seqcial             = 0.
                    //-> Sequencial EPC igual a 0 (zero)


                //-> Fazer calculo dos prefixos GS1
                IF bc-ext-item.log-utiliza-gtin 
                THEN DO:
                    ASSIGN  pTagRfid = "".
                    RUN piCalculaTagRFIDHex   IN h-epcRepository (  INPUT bc-ext-item.cod-gtin,
                                                                    INPUT bc-ext-item.it-codigo,
                                                                    INPUT bc-ext-item.val-seqcial,
                                                                    INPUT bc-ext-item.num-tag-size,
                                                                    INPUT bc-ext-item.num-filter-value,
                                                                    INPUT bc-ext-item.num-company-prefix-size,
                                                                    OUTPUT pTagRfid,
                                                                    OUTPUT TABLE RowErrors).
                    ASSIGN bc-ext-item.cod-prefix-epc             = pTagRfid.

                END.

        
        end.
        input stream s-imp close.
    END.
    ELSE DO:
        {utp/ut-liter.i "Arquivo importa‡Æo Inexistente"}
        RUN utp/ut-msgs.p (INPUT "MSG",
                           INPUT 17006,
                           INPUT (RETURN-VALUE + ":" + tt-param.cArquivo) + "~~" + (RETURN-VALUE + ":" + tt-param.cArquivo)).

        PUT UNFORMATTED TRIM(RETURN-VALUE)
            SKIP.
    END.
END.

IF VALID-HANDLE(h-rfidapi001)
THEN DO:
    DELETE PROCEDURE h-rfidapi001.
    ASSIGN h-rfidapi001 = ?.
END.
IF VALID-HANDLE(h-epcRepository)
THEN DO:
    DELETE PROCEDURE h-epcRepository.
    ASSIGN h-epcRepository = ?.
END.

{utp/ut-liter.i PAR¶METROS * r}
assign  c-parametros = trim(return-value)
        c-destino    = {varinc/var00002.i 04 tt-param.destino}
        c-processo   = IF tt-param.rsProcesso = 1 THEN "Exporta‡Æo" ELSE "Importa‡Æo".

{utp/ut-liter.i IMPRESSÇO * r}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Usu rio * r}
assign tt-param.usuario:label in frame f-det = trim(return-value).
{utp/ut-liter.i Destino * r}
assign c-destino:label in frame f-det = trim(return-value).
{utp/ut-liter.i Arquivo * r}
assign tt-param.cArquivo:label in frame f-det = trim(return-value).
{utp/ut-liter.i Processo * r}
assign c-processo:label in frame f-det = trim(return-value).

disp c-impressao
     c-destino
     tt-param.arq-destino
     tt-param.usuario
     tt-param.cArquivo
     c-processo
     with frame f-det.


run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK".

