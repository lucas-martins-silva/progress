/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
** 
** defini‡Æo da temp-table utilizada no envio para CRM 
*******************************************************************************/

procedure pi-le-xml-param:
    def input  param p-le-XML-rp        as logical no-undo.
    def output param p-da-inic          as date    init today no-undo.
    def output param p-da-fim           as date    init today no-undo.
    def output param p-ls-tipo          as char    no-undo.
    def output param p-rs-envia         as integer init 3 no-undo.
    def output param p-rs-opcao         as INTEGER INIT 1 no-undo.
    def output param p-l-envia-hist     as logical no-undo.
    def output param p-l-envia-doc-vinc as logical no-undo.
    def output param p-rs-destino       as integer init 2 no-undo.
    def output param p-c-arquivo        as char    init "AP1201.LST":U no-undo.
    def output param p-rs-execucao      as integer init 2 no-undo.
    def output param p-rs-fornecedor    as integer init 1 no-undo.
    def output param p-da-ult-exec      as date    no-undo.
    def output param p-hr-ult-exec      as char    no-undo.
    def output param p-da-criacao       as date    no-undo.
    def output param p-hr-criacao       as char    no-undo.

    def var xDoc        as handle  no-undo.
    def var c-arq-param as char    no-undo.
    def var c-lista     as char    no-undo.
    def var c-envia     as char    no-undo.
    DEF VAR c-opcao     AS CHAR    NO-UNDO.
    def var c-data      as char    no-undo.
    def var da-inic     as date    no-undo.
    def var da-fim      as date    no-undo.
    def var ls-tipo     as char    no-undo.
    def var rs-envia    as integer no-undo.
    def var rs-opcao    as INTEGER no-undo.
    def var l-envia-hist as logical no-undo.
    def var l-envia-doc-vinc as logical no-undo.
    def var rs-destino  as integer no-undo.
    def var c-arquivo   as char    no-undo.
    def var rs-execucao as integer no-undo.
    def var rs-fornecedor as integer no-undo.
    def var da-ult-exec as date    no-undo.
    def var hr-ult-exec as char    no-undo.
    def var da-criacao  as date    no-undo.
    def var hr-criacao  as char    no-undo.

    assign c-arq-param = c-localiz-arq-param
                       + "~\"
                       + "AP1201":U
                       + (if p-le-XML-rp = yes then "RP":U else "")
                       + ".XML":U.

    if  search(c-arq-param) = ? then
        return.

    create x-document xDoc. 

    xDoc:LOAD("file":u, c-arq-param, FALSE). 

    empty temp-table tt-element-in no-error.
    empty temp-table tt-attribute-in no-error.

    run app/ap1201c.p (input-output table tt-element-in, 
                       input-output table tt-attribute-in, 
                       input xDoc).

    empty temp-table tt-empresa   no-error.
    empty temp-table tt-estabelec no-error.
    empty temp-table tt-emitente  no-error.
    empty temp-table tt-esp-doc   no-error.

    assign c-lista = "".
    for each tt-element-in no-lock:
        /* data inicial */
        if  tt-element-in.name = "InitialPeriod":U then do:
            assign c-data = replace(tt-element-in.val, "-":u, ",":u).
            if  session:date-format = "dmy":U then
                assign c-data = entry(3, c-data) + "/":u
                              + entry(2, c-data) + "/":u 
                              + entry(1, c-data).
            else
                assign c-data = entry(2, c-data) + "/":u
                              + entry(3, c-data) + "/":u
                              + entry(1, c-data).
            assign da-inic = date(c-data).
        end.

        /* data final */
        if  tt-element-in.name = "FinalPeriod":U then do:
            assign c-data = replace(tt-element-in.val, "-":u, ",":u).
            if  session:date-format = "dmy":U then
                assign c-data = entry(3, c-data) + "/":u
                              + entry(2, c-data) + "/":u
                              + entry(1, c-data).
            else
                assign c-data = entry(2, c-data) + "/":u
                              + entry(3, c-data) + "/":u
                              + entry(1, c-data).
            assign da-fim = date(c-data).
        end.

        /* empresas */
        if  tt-element-in.name = "CompanyCode":U then do:
            find empresa
                where empresa.ep-codigo = integer(tt-element-in.val)
                no-lock no-error.
            if  avail empresa then do:
                find first tt-empresa
                    where tt-empresa.ep-codigo = integer(tt-element-in.val)
                    no-lock no-error.
                if  not avail tt-empresa then do:
                    create tt-empresa.
                    buffer-copy empresa to tt-empresa.
                end.
            end.
        end.

        /* Estabelecimentos */
        if  tt-element-in.name = "BranchCode":U then do:
            find estabelec
                where estabelec.cod-estabel = tt-element-in.val
                no-lock no-error.
            if  avail estabelec then do:
                find first tt-estabelec
                    where tt-estabelec.cod-estabel = tt-element-in.val
                    no-lock no-error.
                if  not avail tt-estabelec then do:
                    create tt-estabelec.
                    buffer-copy estabelec to tt-estabelec.
                end.
            end.
        end.

        /* Clientes */
        if  tt-element-in.name = "CustomerCode":U then do:
            find emitente
                where emitente.cod-emitente = integer(tt-element-in.val)
                no-lock no-error.
            if  avail emitente then do:
                find first tt-emitente
                    where tt-emitente.cod-emitente = integer(tt-element-in.val)
                    no-lock no-error.
                if  not avail tt-emitente then do:
                    create tt-emitente.
                    buffer-copy emitente to tt-emitente.
                end.
            end.
        end.

        /* Esp-doc */
        if  tt-element-in.name = "DocumentClass":U then do:
            find esp-doc
                where esp-doc.cod-esp = tt-element-in.val
                no-lock no-error.
            if  avail esp-doc then do:
                find first tt-esp-doc
                    where tt-esp-doc.cod-esp = tt-element-in.val
                    no-lock no-error.
                if  not avail tt-esp-doc then do:
                    create tt-esp-doc.
                    buffer-copy esp-doc to tt-esp-doc.
                end.
            end.
        end.

        /* tipo */
        if  tt-element-in.name = "DocumentType":U then do:
            assign c-lista = c-lista
                           + (if  c-lista <> "" then "," else "")
                           + tt-element-in.val.
        end.

        /* envia */
        if  tt-element-in.name = "MovimentType":U then do:
            assign c-envia  = tt-element-in.val
                   rs-envia = integer(c-envia).
        end.

        /* Considera */
        if  tt-element-in.name = "Movimented":U then do:
            assign c-opcao  = tt-element-in.val
                   rs-opcao = INTEGER(c-opcao).
        end.

        /* Identifica Fornecedor */
        if  tt-element-in.name = "Identificforn":U then do:
            assign c-opcao  = tt-element-in.val
                   rs-fornecedor = INTEGER(c-opcao).
        end.

        /* envia-historico */
        if  tt-element-in.name = "SendHistory":U then do:
            assign l-envia-hist = (tt-element-in.val = "yes":U).
        end.

        /* envia-documentos-vinculados */
        if  tt-element-in.name = "SendLinkDocument":U then do:
            assign l-envia-doc-vinc = (tt-element-in.val = "yes":U).
        end.

        /* Destino */
        if  tt-element-in.name = "Target":U then do:
            assign rs-destino = integer(tt-element-in.val).
        end.

        /* arquivo */
        if  tt-element-in.name = "File":U then do:
            assign c-arquivo = tt-element-in.val.
        end.

        /* Execucao */
        if  tt-element-in.name = "Exec":U then do:
            assign rs-execucao = integer(tt-element-in.val).
        end.

        /* Data da ultima Execucao */
        if  tt-element-in.name = "LastExecutionDate":U then do:
            assign c-data = replace(tt-element-in.val, "-":u, ",":u).
            if  session:date-format = "dmy":U then
                assign c-data = entry(3, c-data) + "/":u
                              + entry(2, c-data) + "/":u
                              + entry(1, c-data).
            else
                assign c-data = entry(2, c-data) + "/":u
                              + entry(3, c-data) + "/":u
                              + entry(1, c-data).
            assign da-ult-exec = date(c-data).
        end.

        /* Hora da Ultima Execucao */
        if  tt-element-in.name = "LastExecutionTime":U then do:
            assign hr-ult-exec = tt-element-in.val.
        end.

        /* Data da criacao do XML */
        if  tt-element-in.name = "UpdateDate":U then do:
            assign c-data = replace(tt-element-in.val, "-":u, ",":u).
            if  session:date-format = "dmy":U then
                assign c-data = entry(3, c-data) + "/":u
                              + entry(2, c-data) + "/":u
                              + entry(1, c-data).
            else
                assign c-data = entry(2, c-data) + "/":u
                              + entry(3, c-data) + "/":u
                              + entry(1, c-data).
            assign da-criacao = date(c-data).
        end.

        /* Hora da criacao do XML */
        if  tt-element-in.name = "UpdateTime":U then do:
            assign hr-criacao = tt-element-in.val.
        end.
    end.

    assign p-da-inic     = da-inic
           p-da-fim      = da-fim
           p-ls-tipo     = c-lista
           p-rs-envia    = rs-envia
           p-rs-opcao    = rs-opcao
           p-l-envia-hist = l-envia-hist
           p-l-envia-doc-vinc = l-envia-doc-vinc
           p-rs-destino  = rs-destino
           p-c-arquivo   = c-arquivo
           p-rs-execucao = rs-execucao
           p-rs-fornecedor = rs-fornecedor
           p-da-ult-exec = da-ult-exec
           p-hr-ult-exec = hr-ult-exec
           p-da-criacao  = da-criacao
           p-hr-criacao  = hr-criacao.

    empty temp-table tt-element-in no-error.
    empty temp-table tt-attribute-in no-error.
end procedure.

procedure pi-grava-xml-param:
    def input param p-le-XML-rp   as logical no-undo.
    def input param p-da-inic     as date    no-undo.
    def input param p-da-fim      as date    no-undo.
    def input param p-ls-tipo     as char    no-undo.
    def input param p-rs-envia    as integer no-undo.
    def input param p-rs-opcao    AS INTEGER no-undo.
    def input param p-l-envia-hist as logical no-undo.
    def input param p-l-envia-doc-vinc as logical no-undo.
    def input param p-rs-destino  as integer no-undo.
    def input param p-c-arquivo   as char    no-undo.
    def input param p-rs-execucao as integer no-undo.
    def input param p-rs-fornecedor as integer no-undo.
    def input param p-da-ult-exec as date    no-undo.
    def input param p-hr-ult-exec as char    no-undo.
    def input param p-da-criacao  as date    no-undo.
    def input param p-hr-criacao  as char    no-undo.

    def var ic-null     as char    no-undo.
    def var ic-root     as char    no-undo.
    def var ic-financ   as char    no-undo.
    def var ic-sel      as char    no-undo.
    def var ic-par      as char    no-undo.
    def var ic-pri      as char    no-undo.
    def var ic-int      as char    no-undo.
    def var Lc-aux      as char    no-undo.
    def var Lc-aux2     as char    no-undo.
    def var outxml      as handle  no-undo.
    def var c-arq-param as char    no-undo.
    def var i-cont      as integer no-undo.

    empty temp-table tt-element-out no-error.
    empty temp-table tt-attribute-out no-error.

    assign ic-root   = CreateNeoGridDoc("AP1201":U,"1.0 ":U + string(today), "0":U)
           ic-financ = AddElement(ic-root, "Financial":U)
           ic-par    = AddElement(ic-financ, "Parameters":U)
           ic-int    = AddElement(ic-par, "Integration":U).

    /* Selecao */
    assign ic-sel  = AddElement(ic-int, "Selecting":U)
           ic-null = AddEleDate(ic-sel, "InitialPeriod":U, p-da-inic, "")
           ic-null = AddEleDate(ic-sel, "FinalPeriod":U, p-da-fim, "").

    /* empresas */
    assign Lc-aux  = AddElement(ic-sel, "ListOfCompanies":U).
    for each tt-empresa no-lock:
        assign ic-null = AddEleInt(Lc-aux, "CompanyCode":U, tt-empresa.ep-codigo).
    end.

    /* Estabelecimentos */
    assign Lc-aux  = AddElement(ic-sel, "ListOfBranches":U).
    for each tt-estabelec no-lock:
        assign ic-null = AddEleChar(Lc-aux, "BranchCode":U, tt-estabelec.cod-estabel).
    end.

    /* Clientes */
    if  can-find(first tt-emitente) then do:
        assign Lc-aux  = AddElement(ic-sel, "ListOfCustomers":U).
        for each tt-emitente no-lock:
            assign ic-null = AddEleInt(Lc-aux, "CustomerCode":U, tt-emitente.cod-emitente).
        end.
    end.

    /* Esp-doc */
    assign Lc-aux  = AddElement(ic-sel, "ListOfDocumentClass":U).
    for each tt-esp-doc no-lock:
        assign ic-null = AddEleChar(Lc-aux, "DocumentClass":U, tt-esp-doc.cod-esp).
    end.

    /* tipo */
    assign Lc-aux  = AddElement(ic-sel, "ListOfDocumentType":U).
    do  i-cont = 1 to num-entries(p-ls-tipo):
        assign ic-null = AddEleChar(Lc-aux, "DocumentType":U, entry(i-cont, p-ls-tipo)).
    end.

    assign ic-null = AddEleInt(ic-sel, "MovimentType":U, p-rs-envia)
           ic-null = AddEleInt(ic-sel, "Movimented":U, p-rs-opcao)
           ic-null = AddEleInt(ic-sel, "Identificforn":U, p-rs-fornecedor)
           ic-null = AddEleChar(ic-sel, "SendHistory":U, string(p-l-envia-hist))
           ic-null = AddEleChar(ic-sel, "SendLinkDocument":U, string(p-l-envia-doc-vinc)).

    /* Impressao */
    assign ic-pri  = AddElement(ic-int, "Printing":U)
           ic-null = AddEleInt(ic-pri, "Target":U, p-rs-destino).
    if  p-c-arquivo <> "" then
        assign ic-null = AddEleChar(ic-pri, "File":U, p-c-arquivo).
    assign ic-null = AddEleInt(ic-pri, "Exec":U, p-rs-execucao).

    /* Data e Hora a ultima execu‡Æo */
    if  p-da-ult-exec <> ?
    or  p-hr-ult-exec <> "" then do:
        assign ic-pri  = AddElement(ic-int, "LastExecution":U)
               ic-null = AddEleDate(ic-pri, "LastExecutionDate":U, p-da-ult-exec, "")
               ic-null = AddEleChar(ic-pri, "LastExecutionTime":U, p-hr-ult-exec).
    end.

    /* Data da criacao do XML */
    assign ic-null = AddEleDate(ic-int, "UpdateDate":U, p-da-criacao, "").

    /* Hora da criacao do XML */
    assign ic-null = AddEleChar(ic-int, "UpdateTime":U, p-hr-criacao).

    run app/ap1201b.p (input-output table tt-element-out, 
                       input-output table tt-attribute-out, 
                       output outxml).
    assign c-arq-param = c-localiz-arq-param
                       + "~\"
                       + "AP1201":U
                       + (if p-le-XML-rp = yes then "RP":U else "")
                       + ".XML":U.
    outxml:save("file":U, c-arq-param).

    empty temp-table tt-element-out no-error.
    empty temp-table tt-attribute-out no-error.
END PROCEDURE.

/* fim */
