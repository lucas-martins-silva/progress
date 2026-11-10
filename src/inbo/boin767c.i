DEFINE TEMP-TABLE tt-pendencia no-undo 
    FIELD tipo-trans       AS INTEGER   FORMAT "9":U
    FIELD ep-codigo        LIKE empresa.ep-codigo
    FIELD cod-estabel      LIKE estabelec.cod-estabel
    FIELD cod-tip-doc      AS INTEGER   FORMAT ">>9":U
    FIELD chave-doc        AS CHARACTER FORMAT "x(80)":U
    FIELD nr-trans         AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD cod-erro         AS INTEGER   FORMAT ">>>>>9":U
    FIELD desc-erro        AS CHARACTER FORMAT "x(256)":U
    FIELD cod-usuar        LIKE mla-doc-pend-aprov.cod-usuar
    FIELD dt-geracao       LIKE mla-doc-pend-aprov.dt-geracao
    FIELD rowid-pend       AS ROWID     
    INDEX codigo AS PRIMARY cod-tip-doc chave-doc ASCENDING.

DEFINE TEMP-TABLE tt-log-erros-atualiz NO-UNDO
    FIELD tta-cod-estab       AS CHARACTER FORMAT "x(3)":U
    FIELD tta-cod-refer       AS CHARACTER FORMAT "x(10)":U
    FIELD tta-num-seq-refer   AS INTEGER   FORMAT ">>>9":U
    FIELD ttv-num-mensagem    AS INTEGER   FORMAT ">>>>,>>9":U
    FIELD ttv-des-msg-erro    AS CHARACTER FORMAT "x(60)":U
    FIELD ttv-des-msg-ajuda   AS CHARACTER FORMAT "x(40)":U
    FIELD ttv-ind-tip-relacto AS CHARACTER FORMAT "x(15)":U
    FIELD ttv-num-relacto     AS INTEGER   FORMAT ">>>>,>>9":U.

DEFINE TEMP-TABLE tt-param-aprov NO-UNDO
    FIELD ep-codigo                LIKE mla-param-aprov.ep-codigo
    FIELD cod-estabel              LIKE mla-param-aprov.cod-estabel
    FIELD destino-verba            LIKE mla-param-aprov.destino-verba   
    FIELD log-exchange             LIKE mla-param-aprov.log-exchange    
    FIELD log-email                LIKE mla-param-aprov.log-email       
    FIELD compl-email              LIKE mla-param-aprov.compl-email     
    FIELD servidor-email           LIKE mla-param-aprov.servidor-email  
    FIELD porta-email              LIKE mla-param-aprov.porta-email
    FIELD log-1                    LIKE mla-param-aprov.log-1
    FIELD log-email-altern         LIKE mla-param-aprov.log-email-altern
    FIELD log-atachado             LIKE mla-param-aprov.log-atachado
    FIELD assume-perm-prin         AS LOGICAL
    FIELD assume-perm-lotacao-prin AS LOGICAL
    FIELD assume-perm-mestre-prin  AS LOGICAL
    FIELD log-aprovac-altern-dat   LIKE mla-param-aprov.log-aprovac-altern-dat
    FIELD log-integr-fluig         LIKE mla-param-aprov.log-integr-fluig
    FIELD cdn-rej                  LIKE mla-param-aprov.cdn-rej.

DEFINE TEMP-TABLE tt-mla-usuar-aprov NO-UNDO
    FIELD cod-usuar    LIKE mla-usuar-aprov.cod-usuar
    FIELD nome-usuar   LIKE mla-usuar-aprov.nome-usuar
    FIELD e-mail       LIKE mla-usuar-aprov.e-mail
    FIELD recebe-email LIKE mla-usuar-aprov.recebe-email.

DEFINE TEMP-TABLE tt-mla-tipo-doc-aprov NO-UNDO
    FIELD ep-codigo        LIKE mla-tipo-doc-aprov.ep-codigo
    FIELD cod-estabel      LIKE mla-tipo-doc-aprov.cod-estabel 
    FIELD cod-tip-doc      LIKE mla-tipo-doc-aprov.cod-tip-doc
    FIELD verba-aprov      LIKE mla-tipo-doc-aprov.verba-aprov
    FIELD prog-aprova      LIKE mla-tipo-doc-aprov.prog-aprova      
    FIELD prog-rejeita     LIKE mla-tipo-doc-aprov.prog-rejeita     
    FIELD prioridade-aprov LIKE mla-tipo-doc-aprov.prioridade-aprov 
    FIELD des-tip-doc      LIKE mla-tipo-doc-aprov.des-tip-doc      
    FIELD log-2            LIKE mla-tipo-doc-aprov.log-2
    FIELD char-1           LIKE mla-tipo-doc-aprov.char-1
    FIELD log-integr-fluig LIKE mla-tipo-doc-aprov.log-integr-fluig. 

DEFINE TEMP-TABLE tt-mla-perm-aprov NO-UNDO
    FIELD ep-codigo        LIKE mla-perm-aprov.ep-codigo
    FIELD cod-estabel      LIKE mla-perm-aprov.cod-estabel
    FIELD cod-usuar        LIKE mla-perm-aprov.cod-usuar
    FIELD cod-tip-doc      LIKE mla-perm-aprov.cod-tip-doc
    FIELD limite-aprov     LIKE mla-perm-aprov.limite-aprov
    FIELD validade-ini     LIKE mla-perm-aprov.validade-ini
    FIELD validade-fim     LIKE mla-perm-aprov.validade-fim.

DEFINE TEMP-TABLE tt-mla-perm-lotacao NO-UNDO
    FIELD ep-codigo    LIKE mla-perm-lotacao.ep-codig 
    FIELD cod-usuar    LIKE mla-perm-lotacao.cod-usuar 
    FIELD cod-lotacao  LIKE mla-perm-lotacao.cod-lotacao 
    FIELD validade-ini LIKE mla-perm-lotacao.validade-ini 
    FIELD validade-fim LIKE mla-perm-lotacao.validade-fim. 

DEFINE TEMP-TABLE tt-tipo-aprov-doc NO-UNDO
    FIELD ep-codigo     LIKE mla-tipo-aprov-doc.ep-codigo     
    FIELD cod-tip-doc   LIKE mla-tipo-aprov-doc.cod-tip-doc   
    FIELD cod-tip-aprov LIKE mla-tipo-aprov-doc.cod-tip-aprov 
    FIELD nr-min-aprov  LIKE mla-tipo-aprov-doc.nr-min-aprov.  

DEFINE TEMP-TABLE tt-tipo-aprov-item NO-UNDO
    FIELD ep-codigo     LIKE mla-tipo-aprov-item.ep-codigo     
    FIELD it-codigo     LIKE mla-tipo-aprov-item.it-codigo      
    FIELD cod-tip-aprov LIKE mla-tipo-aprov-item.cod-tip-aprov  
    FIELD nr-min-aprov  LIKE mla-tipo-aprov-item.nr-min-aprov. 

DEFINE TEMP-TABLE tt-tipo-aprov-fam NO-UNDO
    FIELD ep-codigo     LIKE mla-tipo-aprov-fam.ep-codigo     
    FIELD fm-codigo     LIKE mla-tipo-aprov-fam.fm-codigo     
    FIELD cod-tip-aprov LIKE mla-tipo-aprov-fam.cod-tip-aprov 
    FIELD nr-min-aprov  LIKE mla-tipo-aprov-fam.nr-min-aprov.  

DEFINE TEMP-TABLE tt-tipo-aprov-ref NO-UNDO
    FIELD ep-codigo     LIKE mla-tipo-aprov-ref.ep-codigo     
    FIELD codigo        LIKE mla-tipo-aprov-ref.codigo   
    FIELD cod-tip-doc   LIKE mla-tipo-aprov-ref.cod-tip-doc
    FIELD cod-tip-aprov LIKE mla-tipo-aprov-ref.cod-tip-aprov 
    FIELD nr-min-aprov  LIKE mla-tipo-aprov-ref.nr-min-aprov. 

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD fm-codigo     LIKE ITEM.fm-codigo.

DEFINE TEMP-TABLE tt-mla-lim-aprov-fam NO-UNDO
    FIELD ep-codigo     LIKE mla-lim-aprov-fam.ep-codigo   
    FIELD fm-codigo     LIKE mla-lim-aprov-fam.fm-codigo   
    FIELD cod-tip-doc   LIKE mla-lim-aprov-fam.cod-tip-doc 
    FIELD cod-usuar     LIKE mla-lim-aprov-fam.cod-usuar   
    FIELD limite-aprov  LIKE mla-lim-aprov-fam.limite-aprov.

DEFINE TEMP-TABLE tt-mla-hierarquia-aprov NO-UNDO
    FIELD ep-codigo    LIKE mla-hierarquia-aprov.ep-codigo  
    FIELD cod-estabel  LIKE mla-hierarquia-aprov.cod-estabel
    FIELD cod-lotacao  LIKE mla-hierarquia-aprov.cod-lotacao
    FIELD cod-tip-doc  LIKE mla-hierarquia-aprov.cod-tip-doc
    FIELD seq-aprov    LIKE mla-hierarquia-aprov.seq-aprov  
    FIELD log-depend   LIKE mla-hierarquia-aprov.log-depend 
    FIELD cod-usuar    LIKE mla-hierarquia-aprov.cod-usuar.

DEFINE TEMP-TABLE tt-mla-hierarquia-faixa NO-UNDO
    FIELD ep-codigo    LIKE mla-hierarquia-faixa.ep-codigo   
    FIELD cod-estabel  LIKE mla-hierarquia-faixa.cod-estabel 
    FIELD cod-lotacao  LIKE mla-hierarquia-faixa.cod-lotacao 
    FIELD cod-tip-doc  LIKE mla-hierarquia-faixa.cod-tip-doc 
    FIELD num-faixa    LIKE mla-hierarquia-faixa.num-faixa   
    FIELD seq-aprov    LIKE mla-hierarquia-faixa.seq-aprov   
    FIELD log-depend   LIKE mla-hierarquia-faixa.log-depend
    FIELD cod-usuar    LIKE mla-hierarquia-faixa.cod-usuar.

DEFINE TEMP-TABLE tt-mla014e NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

DEFINE TEMP-TABLE tt-moeda NO-UNDO
    FIELD mo-codigo LIKE moeda.mo-codigo
    FIELD sigla     LIKE moeda.sigla.

DEFINE TEMP-TABLE tt-mla-rej-aprov NO-UNDO
    FIELD cod-rejeicao     LIKE mla-rej-aprov.cod-rejeicao
    FIELD des-rejeicao     LIKE mla-rej-aprov.des-rejeicao
    FIELD obriga-narrativa LIKE mla-rej-aprov.obriga-narrativa
    FIELD log-1            LIKE mla-rej-aprov.log-1.

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence AS INTEGER
    FIELD ErrorNumber   AS INTEGER
    FIELD ErrorDescription AS CHAR
    FIELD ErrorParameters AS CHAR
    FIELD ErrorType       AS CHAR
    FIELD Errorhelp       AS CHAR
    FIELD Errorsubtype    AS CHAR.

DEFINE TEMP-TABLE RowErrorsAux2 NO-UNDO LIKE RowErrorsAux.
