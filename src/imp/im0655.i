{include/i_dbvers.i}
/************************************************************************************************************
**
** IM0655.I - Definicoes de temp-tables
**
************************************************************************************************************/
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}

    def temp-table tt-raw-digita
        field raw-digita as raw.

    define temp-table tt-param
        field destino                 as integer
        field arquivo                 as char
        field usuario                 as char
        field data-exec               as date
        field hora-exec               as integer
        field ep-codigo               LIKE empresa.ep-codigo
        field l-tipo                  as logical format "Sim/NÆo" initial no                 
        field l-observacao            as logical format "Sim/NÆo" initial no
        field l-ordens                as logical format "Sim/NÆo" initial no
        field l-desp                  as logical format "Sim/NÆo" initial no 
        FIELD l-adic-embarq           AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO 
        field detalhe-desp            as integer
        field i-atraso                as integer
        field i-situacao              as integer
        field i-sit-emb               as integer  
        field dt-cotacao              as date format "99/99/9999"
        field da-data-ini             as date format "99/99/9999" initial &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF
        field da-data-fim             as date format "99/99/9999"
        field c-est-ini               like estabelec.cod-estabel
        field c-est-fim               like estabelec.cod-estabel initial "ZZZZZ"
        field c-proc-ini              like processo-imp.nr-proc-imp
        field c-proc-fim              like processo-imp.nr-proc-imp initial "ZZZZZZZZZZZZ"
        field i-exp-ini               like processo-imp.cod-exportador
        field i-exp-fim               like processo-imp.cod-exportador initial "999999999"
        field i-itiner-ini            like itinerario.cod-itiner
        field i-itiner-fim            like itinerario.cod-itiner initial "99999"
        field i-pto-emb-ini           like itinerario.pto-embarque
        field i-pto-emb-fim           like itinerario.pto-embarque initial "99999"
        field i-pto-des-ini           like itinerario.pto-desembarque 
        field i-pto-des-fim           like itinerario.pto-desembarque initial "99999"
        field i-local                 as integer
        field moeda                   like moeda.mo-codigo
        field i-grupo-ini             like grup-estoque.ge-codigo
        field i-grupo-fim             like grup-estoque.ge-codigo
        field c-fam-ini               like familia.fm-codigo
        field c-fam-fim               like familia.fm-codigo
        field c-item-ini              like item.it-codigo
        field c-item-fim              like item.it-codigo initial "ZZZZZZZZZZZZZZZZ"
        field c-fatura-ini            like invoice-emb-imp.nr-invoice
        field c-fatura-fim            like invoice-emb-imp.nr-invoice initial "ZZZZZZZZZZZZ"
        field c-embarque-ini          like embarque-imp.embarque
        field c-embarque-fim          like embarque-imp.embarque initial "ZZZZZZZZZZZZZZZZ"
        field l-peso-cub              as logical format "Sim/NÆo" 
        field nr-conhecto-master-ini  as char
        field nr-conhecto-master-fim  as char 
        field nr-conhecto-house-ini   as char
        field nr-conhecto-house-fim   as char 
        field declar-import-ini       as char
        field declar-import-fim       as char
        field veiculo-transp-ini      as char 
        field veiculo-transp-fim      as char
        field i-opcao                 as integer
        field l-detalha-despesa       as logical format "Sim/NÆo" initial no
        FIELD iPtoSolicLiIni          LIKE itinerario.cdn-pto-solic-licenciam-import
        FIELD iPtoSolicLiFim          LIKE itinerario.cdn-pto-solic-licenciam-import
        FIELD cLicencImportIni        LIKE licenciam-import-oc.licenca-import 
        FIELD cLicencImportFim        LIKE licenciam-import-oc.licenca-import 
        FIELD lDetalhaLi              AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO
        FIELD via-transp-ini          AS INT
        FIELD via-transp-fim          AS INT
        FIELD lantecipacao            AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO.

/* IM0655.I */
