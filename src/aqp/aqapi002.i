/***************************************************************************
**                                                                        **
**    AQAPI002.I - Retorno dos resultados das an lises externas           **
**                                                                        **
**    DEFINI€ÇO DAS TEMP-TABLES                                           **
**                                                                        **  
****************************************************************************/
 
def temp-table tt_retorno_analises no-undo
    field ttv_cdn_produt                   as Integer format ">>>,>>>,>>9"
    field ttv_num_ficha                    as integer format ">>>>,>>9"
    field ttv_dat_restdo                   as date format "99/99/9999"
    field ttv_cdn_exam                     as Integer format ">>>>>9"
    field ttv_cdn_compon                   as Integer format ">>>9"
    field ttv_des_compon                   as character format "x(30)"
    field ttv_val_restdo                   as decimal format "->,>>>,>>9.9999999" decimals 7
    field tta_cod_prop_rural               as character format "x(16)"
    .

def temp-table tt_produtores no-undo
    field ttv_cdn_produt                   as Integer format ">>>,>>>,>>9"
    field tta_cod_prop_rural               as character format "x(16)"
    .
