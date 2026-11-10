def new global shared temp-table tt-tit-ap-sel no-undo
    field row-tit-ap as ROWID
    INDEX codigo row-tit-ap.

def new global shared temp-table tt-relacto NO-UNDO
    FIELD row-relacto AS ROWID
    INDEX codigo row-relacto.

def new global shared temp-table tt-tit-ap NO-UNDO LIKE tit-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-mov-ap NO-UNDO LIKE mov-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-che-emit NO-UNDO LIKE che-emit
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-cheque NO-UNDO LIKE cheque
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-portador NO-UNDO LIKE portador
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-tit-conta-ap NO-UNDO LIKE tit-conta-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-his-d-ap NO-UNDO LIKE his-d-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-usuar-autoriza-tit NO-UNDO LIKE usuar-autoriza-tit
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-impto-tit-ap NO-UNDO LIKE impto-tit-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-espec-ap NO-UNDO LIKE espec-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-emitente NO-UNDO LIKE emitente
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-grupo-fornec NO-UNDO LIKE grupo-fornec
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-conta-ap NO-UNDO LIKE conta-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-conta-contab NO-UNDO LIKE conta-contab
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-conta NO-UNDO LIKE conta
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-sub-conta NO-UNDO LIKE sub-conta
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-banco NO-UNDO LIKE banco
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-agencia NO-UNDO LIKE agencia
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-cta-corrente NO-UNDO LIKE cta-corrente
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-estabelec NO-UNDO LIKE estabelec
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-empresa NO-UNDO LIKE empresa
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-param-ap NO-UNDO LIKE param-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

&if  "{&mgadm_version}" >= "2.02" &then

    def new global shared temp-table tt-cta-emitente NO-UNDO LIKE cta-emitente
        FIELD r-rowid AS ROWID
        INDEX codigo r-rowid.

    def new global shared temp-table tt-acum-pagto NO-UNDO LIKE acum-pagto
        FIELD r-rowid AS ROWID
        INDEX codigo r-rowid.

&endif

def new global shared temp-table tt-usuar-permissao-ap NO-UNDO LIKE usuar-permissao
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-emite-ap NO-UNDO LIKE emite-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-compl-retenc-impto-pagto NO-UNDO LIKE compl-retenc-impto-pagto
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-acum-imposto-pagto NO-UNDO LIKE acum-imposto-pagto
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-imposto-pagto NO-UNDO LIKE imposto-pagto
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-bord-tit NO-UNDO LIKE bord-tit
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-bord-rec NO-UNDO LIKE bord-rec
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-lin-b-ap NO-UNDO LIKE lin-b-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-doc-b-ap NO-UNDO LIKE doc-b-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-l-ant-ap NO-UNDO LIKE l-ant-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-l-pre-ap NO-UNDO LIKE l-pre-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-impto-tit-pend-ap NO-UNDO LIKE impto-tit-pend-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-dirf-ap NO-UNDO LIKE dirf-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-dirf-apf NO-UNDO LIKE dirf-apf
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-prog_dtsul NO-UNDO LIKE prog_dtsul
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-tipo-tax NO-UNDO LIKE tipo-tax
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-ext-fasb NO-UNDO LIKE ext-fasb
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-ext-cmi NO-UNDO LIKE ext-cmi
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-calen-coml NO-UNDO LIKE calen-coml
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-doc-i-ap NO-UNDO LIKE doc-i-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-lin-i-ap NO-UNDO LIKE lin-i-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-lin-conta-ap NO-UNDO LIKE lin-conta-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-hist-padrao NO-UNDO LIKE hist-padrao
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-bordero-ap NO-UNDO LIKE bordero-ap
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.

def new global shared temp-table tt-nota-dup NO-UNDO LIKE nota-dup
    FIELD r-rowid AS ROWID
    INDEX codigo r-rowid.
