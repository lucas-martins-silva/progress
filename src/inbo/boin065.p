/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN065 2.00.00.005} /*** "010005" 17/06/2025 16:40:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin065 MUT}
&ENDIF

/*
**  BOIN065.P
**
**  contrato-for - Contem o Contrato de Fornecimento
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY contrato-for
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME contrato-for
 
{include/boini.i}
{cdp/cdcfgdis.i}
 
 
{inbo/boin065.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:
 
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
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
 
procedure findContrato:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-nr-contrato as char no-undo.
    def output parameter c-return as char no-undo.
 
    &if "{&bf_dis_versao_ems}" >= "2.02" &then
        find contrato-for where
             contrato-for.nr-contrato = integer(c-nr-contrato)
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
    &else    
        find contrato-for where
             contrato-for.nr-contrato = c-nr-contrato
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
    &endif

    run endMethod ("find").
end procedure.
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-emitente = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estab-cobr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estab-orig = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-mensagem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-tipo-contrat = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-transp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    &if "{&bf_dis_versao_ems}" >= "2.02" &then    
        if rowObject.dt-contrato = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
    &else
        if rowObject.dat-contrat = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif

 
    &if "{&bf_dis_versao_ems}" >= "2.02" &then    
        if rowObject.dt-ter-validade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
    &else
        if rowObject.dat-fim-validade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif


    &if "{&bf_dis_versao_ems}" >= "2.02" &then    
        if rowObject.dt-ini-validade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
    &else
        if rowObject.dat-ini-validade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif

 
    if rowObject.dat-revisao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-contrato = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-ini-validade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-ter-validade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    &if "{&bf_dis_versao_ems}" < "2.02" &then    
        if rowObject.estado = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif
 
    if rowObject.frete = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.gestor-tecnico = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.impr-contrat = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-libera = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.mo-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.moeda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.motivo-cancel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.natureza = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-contrato = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    &if "{&bf_dis_versao_ems}" < "2.02" &then    
        if rowObject.situacao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif
 
    if rowObject.sld-val-receb = ? then do:
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
    if rowObject.cod-emitente = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-emitente 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estab-cobr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-estab-cobr 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estab-orig = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-estab-orig 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-mensagem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-mensagem 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-tipo-contrat = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-tipo-contrat 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-transp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-transp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    &if "{&bf_dis_versao_ems}" >= "2.02" &then    
        if rowObject.dt-contrato = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} dat-contrat 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
    &else
        if rowObject.dat-contrat = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} dat-contrat 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif
    
    &if "{&bf_dis_versao_ems}" >= "2.02" &then    
        if rowObject.dt-ter-validade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} dat-fim-validade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
    &else
        if rowObject.dat-fim-validade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} dat-fim-validade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif

    
    &if "{&bf_dis_versao_ems}" >= "2.02" &then    
        if rowObject.dt-ini-validade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} dat-ini-validade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
    &else
        if rowObject.dat-ini-validade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} dat-ini-validade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif

 
    if rowObject.dat-revisao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} dat-revisao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-contrato = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} dt-contrato 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-ini-validade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} dt-ini-validade 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-ter-validade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} dt-ter-validade 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    &if "{&bf_dis_versao_ems}" < "2.02" &then    
        if rowObject.estado = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} estado 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif
 
    if rowObject.frete = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} frete 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.gestor-tecnico = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} gestor-tecnico 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.impr-contrat = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} impr-contrat 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-libera = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} log-libera 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.mo-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} mo-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.moeda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} moeda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.motivo-cancel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} motivo-cancel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.natureza = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} natureza 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-contrato = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} nr-contrato 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    &if "{&bf_dis_versao_ems}" < "2.02" &then    
        if rowObject.situacao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} situacao 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
    &endif
 
    if rowObject.sld-val-receb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} sld-val-receb 1}
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
        find contrato-for where
            contrato-for.nr-contrato = rowObject.nr-contrato
            no-lock no-error.
        if avail contrato-for then do:
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
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.

    &if "{&bf_dis_versao_ems}" >= "2.02" &then     
        case c-field:
            when "char-1" then c-value = RowObject.char-1.
            when "char-2" then c-value = RowObject.char-2.
            when "check-sum" then c-value = RowObject.check-sum.
            when "cod-comprado" then c-value = RowObject.cod-comprado.
            when "cod-estab-cobr" then c-value = RowObject.cod-estab-cobr.
            when "cod-estab-entr" then c-value = RowObject.cod-estab-entr.
            when "cod-estab-orig" then c-value = RowObject.cod-estab-orig.
            when "cod-estabel" then c-value = RowObject.cod-estabel.
            when "cod-projeto" then c-value = RowObject.cod-projeto.
            when "conta-contab" then c-value = RowObject.conta-contab.
            when "contato" then c-value = RowObject.contato.
            when "des-contrat" then c-value = RowObject.des-contrat.
            when "gestor-tecnico" then c-value = RowObject.gestor-tecnico.
            when "motivo-cancel" then c-value = RowObject.motivo-cancel.
            when "narrat-contrat" then c-value = RowObject.narrat-contrat.
            when "nr-contrato" then integer(c-value) = RowObject.nr-contrato.
            when "observacao" then c-value = RowObject.observacao.
            when "versao" then c-value = RowObject.versao.
            otherwise return error.
        end case.
    &else
        case c-field:
            when "char-1" then c-value = RowObject.char-1.
            when "char-2" then c-value = RowObject.char-2.
            when "check-sum" then c-value = RowObject.check-sum.
            when "cod-comprado" then c-value = RowObject.cod-comprado.
            when "cod-estab-cobr" then c-value = RowObject.cod-estab-cobr.
            when "cod-estab-entr" then c-value = RowObject.cod-estab-entr.
            when "cod-estab-orig" then c-value = RowObject.cod-estab-orig.
            when "cod-estabel" then c-value = RowObject.cod-estabel.
            when "cod-projeto" then c-value = RowObject.cod-projeto.
            when "conta-contab" then c-value = RowObject.conta-contab.
            when "contato" then c-value = RowObject.contato.
            when "des-contrat" then c-value = RowObject.des-contrat.
            when "gestor-tecnico" then c-value = RowObject.gestor-tecnico.
            when "motivo-cancel" then c-value = RowObject.motivo-cancel.
            when "narrat-contrat" then c-value = RowObject.narrat-contrat.
            when "nr-contrato" then c-value = RowObject.nr-contrato.
            when "observacao" then c-value = RowObject.observacao.
            when "versao" then c-value = RowObject.versao.
            otherwise return error.
        end case.
    &endif
    
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "acum-rec-qtd" then c-value = RowObject.acum-rec-qtd.
        when "acum-rec-val" then c-value = RowObject.acum-rec-val.
        when "acum-val-pago" then c-value = RowObject.acum-val-pago.
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "qtd-total" then c-value = RowObject.qtd-total.
        when "sal-qtd-liber-med" then c-value = RowObject.sal-qtd-liber-med.
        when "sld-qtd" then c-value = RowObject.sld-qtd.
        when "sld-qtd-liber" then c-value = RowObject.sld-qtd-liber.
        when "sld-qtd-med" then c-value = RowObject.sld-qtd-med.
        when "sld-val" then c-value = RowObject.sld-val.
        when "sld-val-liber" then c-value = RowObject.sld-val-liber.
        when "sld-val-liber-med" then c-value = RowObject.sld-val-liber-med.
        when "sld-val-med" then c-value = RowObject.sld-val-med.
        when "sld-val-receb" then c-value = RowObject.sld-val-receb.
        when "val-fatur-minimo" then c-value = RowObject.val-fatur-minimo.
        when "val-total" then c-value = RowObject.val-total.
        when "variacao-preco" then c-value = RowObject.variacao-preco.
        when "variacao-qtd" then c-value = RowObject.variacao-qtd.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-cond-fatur" then c-value = RowObject.cod-cond-fatur.
        when "cod-cond-pag" then c-value = RowObject.cod-cond-pag.
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "cod-mensagem" then c-value = RowObject.cod-mensagem.
        when "cod-tipo-contrat" then c-value = RowObject.cod-tipo-contrat.
        when "cod-transp" then c-value = RowObject.cod-transp.
        /*when "estado" then c-value = RowObject.estado.*/
        when "frete" then c-value = RowObject.frete.
        when "ind-control-rec" then c-value = RowObject.ind-control-rec.
        when "ind-sit-contrat" then c-value = RowObject.ind-sit-contrat.
        when "ind-via-envio" then c-value = RowObject.ind-via-envio.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "mo-codigo" then c-value = RowObject.mo-codigo.
        when "moeda" then c-value = RowObject.moeda.
        when "natureza" then c-value = RowObject.natureza.
        when "nro-proc-saida" then c-value = RowObject.nro-proc-saida.
        /*when "situacao" then c-value = RowObject.situacao.*/
        when "tp-fornecim" then c-value = RowObject.tp-fornecim.
        when "tp-freq" then c-value = RowObject.tp-freq.
        when "via-transp" then c-value = RowObject.via-transp.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "dat-contrat" then c-value = RowObject.dt-contrato.
        when "dat-fim-validade" then c-value = RowObject.dt-ter-validade.
        when "dat-ini-validade" then c-value = RowObject.dt-ini-validade.
        when "dat-revisao" then c-value = RowObject.dat-revisao.
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "dt-contrato" then c-value = RowObject.dt-contrato.
        when "dt-ini-validade" then c-value = RowObject.dt-ini-validade.
        when "dt-ter-validade" then c-value = RowObject.dt-ter-validade.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "impr-contrat" then c-value = RowObject.impr-contrat.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "log-libera" then c-value = RowObject.log-libera.
        otherwise return error.
    end case.
end procedure.
 
