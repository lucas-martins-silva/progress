/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i UPC-ABAPI010-PT0501 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i upc-abapi010-pt0501 MUP}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2005)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/****************************************************************************
** Programa: upc-abapi010-pt0501.p
** Objetivo: Chamar API de Integra‡Æo do Patrim“nio no EMS2 com o Frotas
** Autor...: Sandro Kellermann de Carvalho - its0121
** Data....: maio/2005
****************************************************************************/

def input param p-ind-event  as char          no-undo.
def input param p-ind-object as char          no-undo.
def input param p-wgh-object as handle        no-undo.
def input param p-wgh-frame  as widget-handle no-undo.
def input param p-cod-table  as char          no-undo.
def input param p-row-table  as rowid         no-undo.

DEF VAR h-objeto AS WIDGET-HANDLE  NO-UNDO.
DEFINE VARIABLE hShowMsg AS HANDLE NO-UNDO.

define variable c-objeto as char  FORMAT "x(30)":U  no-undo.
assign c-objeto = entry(num-entries(p-wgh-object:file-name, "~/"), p-wgh-object:file-name, "~/").

if p-ind-event  = "ASSIGN":U       and
   p-ind-object = "VIEWER":U       and
   c-objeto     = "pt0501-v05.w":U THEN DO:

    /*defini‡Æo temp tables*/
    {abp/abapi010.i} 

    CREATE tt_trans_bem.

    DO:  /*captura o valor do campos de tela cod-estabel e centro custo*/
        assign h-objeto = p-wgh-frame:FIRST-CHILD.     
        do  while valid-handle(h-objeto):
            IF  h-objeto:TYPE <> "field-group":U THEN DO:
                
                IF  h-objeto:NAME = "cod-estabel":U THEN
                    ASSIGN tt_trans_bem.ttv_cod_estab = h-objeto:SCREEN-VALUE.
                ELSE
                    IF  h-objeto:NAME = "sc-codigo":U THEN
                        ASSIGN tt_trans_bem.ttv_cod_ccusto = h-objeto:SCREEN-VALUE.

                IF tt_trans_bem.ttv_cod_estab <> "":U  AND tt_trans_bem.ttv_cod_ccusto <> "":U THEN
                    LEAVE.

                assign h-objeto = h-objeto:NEXT-SIBLING.
            END.
            ELSE DO:
                Assign h-objeto = h-objeto:first-child.
            END.    
        end.
    END.
    /*recupera os valores da chave do bem na tabela*/
    FOR FIRST bem FIELDS (ep-codigo bm-codigo bm-indice) WHERE rowid(bem) = p-row-table NO-LOCK:
        /*grava os valores na tt para passar para a api*/
        ASSIGN tt_trans_bem.ttv_cod_empresa     = string(bem.ep-codigo)
               tt_trans_bem.ttv_num_bem_pat     = bem.bm-codigo
               tt_trans_bem.ttv_num_seq_bem_pat     = bem.bm-indice
               tt_trans_bem.ttv_cod_cta_pat = "":U                       /*Conta patrim“nio s¢ ‚ usada no EMS5*/
               tt_trans_bem.ttv_dat_trans     = TODAY                      /*data atual*/
               tt_trans_bem.ttv_hra_trans     = string(TIME,"HH:MM:SS":U). /*hora atual*/

        /*chamada da api*/
        RUN abp/abapi010.p (INPUT  TABLE tt_trans_bem,
                            OUTPUT TABLE tt_row_errors).
        CREATE rowerrors.
        ASSIGN RowErrors.ErrorSequence = tt_row_errors.ttv_num_seq_erro
               RowErrors.ErrorNumber   = tt_row_errors.ttv_num_erro
               RowErrors.ErrorDescription = tt_row_errors.ttv_des_erro
               RowErrors.ErrorParameters = tt_row_errors.ttv_des_param
               RowErrors.ErrorType = tt_row_errors.ttv_des_type
               ROWErrors.ErrorHelp = tt_row_errors.ttv_des_help
               RowErrors.ErrorSubType = tt_row_errors.ttv_des_sub_type.

        /*verifica erros gerados na api*/
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:

            /** Instancia aplicativo **/
            {method/showmessage.i1}
            /** Mostra caixa com erros **/
            {method/showmessage.i2 &Modal="YES"}
            /*elimina handle da memoria*/
            {method/showmessage.i3}

            RETURN "NOK":U.
        END.  
    END. /*FOR FIRST bem*/
END. /*if p-ind-event*/

RETURN "OK":U.

/*fim upc*/
