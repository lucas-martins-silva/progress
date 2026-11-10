/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN046 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN046 MUT}
&ENDIF

/*
**  BOIN046.P
**
**  classif-fisc - Arquivo das Classificações Fiscais
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY classif-fisc
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME classif-fisc
 
{include/boini.i}
 
{inbo/boin046.i RowObject}

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/*********Vari veis SetConstraint2 e 3*********/
def var c-class-fisc-ini as char  no-undo. 
def var c-class-fisc-fim as char  no-undo.
def var c-desc-class-ini as char no-undo.
def var c-desc-class-fim as char no-undo.
 

procedure setConstraintClassFiscal:
def input param p-class-fisc-ini as char no-undo. 
def input param p-class-fisc-fim as char no-undo.
def input param p-desc-class-ini as char no-undo.
def input param p-desc-class-fim as char no-undo.

assign c-class-fisc-ini = p-class-fisc-ini
       c-class-fisc-fim = p-class-fisc-fim
       c-desc-class-ini = p-desc-class-ini
       c-desc-class-fim = p-desc-class-fim.

end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                      where   {&TABLE-NAME}.class-fiscal >= c-class-fisc-ini  and
                                              {&TABLE-NAME}.class-fiscal <= c-class-fisc-fim  and 
                                              {&TABLE-NAME}.descricao    >= c-desc-class-ini and
                                              {&TABLE-NAME}.descricao    <= c-desc-class-fim 
                                              by {&TABLE-NAME}.class-fiscal
                                              INDEXED-REPOSITION.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                      where   {&TABLE-NAME}.class-fiscal >= c-class-fisc-ini  and
                                              {&TABLE-NAME}.class-fiscal <= c-class-fisc-fim  and
                                              {&TABLE-NAME}.descricao    >= c-desc-class-ini and
                                              {&TABLE-NAME}.descricao    <= c-desc-class-fim 
                                              by {&TABLE-NAME}.descricao
                                              INDEXED-REPOSITION.
    end case.
    assign l-query = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

&if defined(bf-mat-comex) &then            
&else 
    procedure findClass_fiscal:
        /*
        **  Procura pelo indice, caso nao ache,
        **  retorna mensagem de erro padrao do EMS.
        */
        run startMethod ("find").
        def input parameter c-class-fiscal as char no-undo.
        def output parameter c-return as char no-undo.
     
        find first classif-fisc where
            classif-fisc.class-fiscal = c-class-fiscal
            no-lock no-error.
        if not avail {&TABLE-NAME} then do:
            {utp/ut-table.i mgind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign c-return = return-value.
        end.
        else do:
           run setCurrent.
        end.
        run endMethod ("find").
    end procedure.
     
    procedure validateFields:
        /*
        **  Valida Fields
        */
        find first rowObject
            no-lock no-error.
     
        run startMethod ("validateFields").
        if rowObject.aliquota-ipi = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.class-fiscal = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.descricao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.finalidade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        run endMethod ("validateFields").
     
    end procedure.
     
    procedure validateCreate:
        /*
        **  Valida cria‡Æo da tabela/duplicidade de registro.
        */
        def input  parameter table for RowObject.
        def output parameter table for tt-bo-erro.
        def output parameter r-chave as rowid.
     
        run initializeValidate.
        run startMethod ("validateCreate").
     
        for each tt-bo-erro:
            delete tt-bo-erro.
        end.
     
        find first rowObject
            no-lock no-error.
        if rowObject.aliquota-ipi = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} aliquota-ipi 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.class-fiscal = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} class-fiscal 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.descricao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} descricao 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.finalidade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} finalidade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        find first tt-bo-erro
            no-lock no-error.
        if not available tt-bo-erro then do:
            find classif-fisc where
                classif-fisc.class-fiscal = rowObject.class-fiscal
                no-lock no-error.
            if avail classif-fisc then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i mgind {&TABLE-NAME} 1}
                run utp/ut-msgs.p (input "msg",
                                   input 8,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 8
                       tt-bo-erro.mensagem     = return-value.
            end.
        end.
     
        run validateFields.
        find first tt-bo-erro
            no-lock no-error.
     
        if not avail tt-bo-erro then do:
           run executeCreate.
           assign r-chave = to-rowid(return-value).
        end.
     
        run endMethod ("validateCreate").
    end procedure.
&endif    
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "class-fiscal" then c-value = RowObject.class-fiscal.
        when "descricao" then c-value = RowObject.descricao.
        when "tar-ext-com" then c-value = RowObject.tar-ext-com.
        when "un-abr-IBGE" then c-value = RowObject.un-abr-IBGE.
        when "unidade" then c-value = RowObject.unidade.
        &if defined(bf-mat-comex) &then            
        &else 
            when "char-2" then c-value = RowObject.char-2.        
            when "check-sum" then c-value = RowObject.check-sum.        
        &endif
        &if '{&bf_mat_versao_ems}' >= '2.062' &then
            when "des-descr-detdo" then c-value = RowObject.des-descr-detdo.        
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "aliquota-imp" then c-value = RowObject.aliquota-imp.
        when "aliquota-ipi" then c-value = RowObject.aliquota-ipi.
        when "cod-mercosul" then c-value = RowObject.cod-mercosul.
        when "cod-naladi" then c-value = RowObject.cod-naladi.
        when "cod-naladi-sh" then c-value = RowObject.cod-naladi-sh.
        when "cod-ncm" then c-value = RowObject.cod-ncm.
        when "dec-1" then c-value = RowObject.dec-1.
        &if defined(bf-mat-comex) &then            
        &else 
            when "dec-2" then c-value = RowObject.dec-2.        
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-imp-cla" then c-value = RowObject.cod-imp-cla.
        when "cod-un-IBGE" then c-value = RowObject.cod-un-IBGE.
        when "cod-unidade" then c-value = RowObject.cod-unidade.
        when "finalidade" then c-value = RowObject.finalidade.
        when "int-1" then c-value = RowObject.int-1.
        &if defined(bf-mat-comex) &then            
        &else         
            when "int-2" then c-value = RowObject.int-2.
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        &if defined(bf-mat-comex) &then            
        &else     
            when "data-1" then c-value = RowObject.data-1.
            when "data-2" then c-value = RowObject.data-2.
        &endif            
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:    
        when "log-1" then c-value = RowObject.log-1.
        &if defined(bf-mat-comex) &then            
        &else         
            when "log-2" then c-value = RowObject.log-2.
        &endif
        otherwise return error.
    end case.
end procedure.
 
