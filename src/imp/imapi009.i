DEFINE TEMP-TABLE tt-estabelec no-undo         LIKE estabelec.
                                               
DEFINE TEMP-TABLE tt-embarque no-undo          LIKE embarque-imp
    field desc-via-transp                      as char format "X(40)"
    field desc-situacao                        as char format "X(40)"
    FIELD r-rowid                              AS ROWID.
                                               
DEFINE TEMP-TABLE tt-processo no-undo          LIKE processo-imp
    field desc-via-transp                      as char format "X(40)"
    field desc-situacao                        as char format "X(40)".
                                               
DEFINE TEMP-TABLE tt-pedido no-undo            LIKE pedido-compr
    field desc-situacao                        as char format "X(40)"
    FIELD desc-cond-pagto                      LIKE cond-pagto.descricao.
                                               
DEFINE TEMP-TABLE tt-ordens-embarque no-undo   LIKE ordens-embarque.
                                               
DEFINE TEMP-TABLE tt-banco no-undo             LIKE banco.

DEFINE TEMP-TABLE tt-inco-cx no-undo           LIKE inco-cx.

DEFINE TEMP-TABLE tt-itinerario no-undo        LIKE itinerario.

DEFINE TEMP-TABLE tt-mensagens no-undo         LIKE mensagem.
                                               
DEFINE TEMP-TABLE tt-agencia no-undo           LIKE agencia.
                                               
DEFINE TEMP-TABLE tt-emitente no-undo          LIKE emitente
    FIELD cod-itiner-exp                       LIKE emitente-cex.cod-itiner-exp
    FIELD cod-idioma                           LIKE emitente-cex.cod-idioma
    FIELD cod-aba                              LIKE emitente-cex.cod-aba
    FIELD cod-repres                           LIKE emitente-cex.cod-repres
    FIELD cod-incoterm-exp                     LIKE emitente-cex.cod-incoterm-exp
    FIELD cod-itiner-imp                       LIKE emitente-cex.cod-itiner-imp
    FIELD cod-incoterm-imp                     LIKE emitente-cex.cod-incoterm-imp
    FIELD log-desp-inclusas                    LIKE emitente-cex.log-desp-inclusas
    FIELD nr-tab                               LIKE emitente-cex.nr-tab
    FIELD cod-pto-contr                        LIKE emitente-cex.cod-pto-contr
    FIELD des-layout-origin-comerc-invoi       LIKE emitente-cex.des-layout-origin-comerc-
    FIELD des-layout-origin-packing-list       LIKE emitente-cex.des-layout-origin-packing
    FIELD des-layout-origin-proform-invoi      LIKE emitente-cex.des-layout-origin-proform
    FIELD cdn-despa-import                     LIKE emitente-cex.cdn-despa-import
    FIELD cdn-despa-exter-import               LIKE emitente-cex.cdn-despa-exter-import
    FIELD cdn-segurad-import                   LIKE emitente-cex.cdn-segurad-import
    FIELD cdn-corretor-cambio-import           LIKE emitente-cex.cdn-corretor-cambio-impor
    FIELD cdn-corretor-import                  LIKE emitente-cex.cdn-corretor-import
    FIELD marca-1                              LIKE emitente-cex.marca-1
    FIELD marca-2                              LIKE emitente-cex.marca-2
    FIELD marca-3                              LIKE emitente-cex.marca-3
    FIELD marca-4                              LIKE emitente-cex.marca-4
    FIELD marca-5                              LIKE emitente-cex.marca-5
    FIELD des-layout-origin-ped-cambio         LIKE emitente-cex.des-layout-origin-ped-cambio
    FIELD des-layout-origin-instruc-embarq     LIKE emitente-cex.des-layout-origin-instruc-embarq.

DEFINE TEMP-TABLE tt-transporte NO-UNDO        LIKE transporte.

DEFINE TEMP-TABLE tt-cond-pagto no-undo        LIKE cond-pagto
    field narrativa                            LIKE narrativa.descricao. 

DEFINE TEMP-TABLE tt-emb-pto-contr   NO-UNDO
    FIELD pto-contr                  LIKE pto-contr.cod-pto-contr
    FIELD desc-pto-contr             LIKE pto-contr.descricao
    FIELD tp-pto-contr               AS INTEGER
    FIELD data-prev-pto-contr        AS DATE
    FIELD data-ult-prev-pto-contr    AS DATE
    FIELD data-efet-pto-contr        AS DATE
    FIELD unid-referencial           LIKE pto-contr.unid-referencial.

                                               

