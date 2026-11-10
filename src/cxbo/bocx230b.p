/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX230B 2.00.00.025 } /*** "010025" 07/10/2024 16:59:55 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx230b MUT}
&ENDIF


/*******************************************************************************
**
**  BOCX230B.P
**
**  historico-embarque - Historico Embarque
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-historico
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-historico

{include/boini.i}
{cxbo/bocx230.i RowObject}
{cxbo/bocx230.i tt-historico}
{cxbo/bocx230.i tt-historico-tmp}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/*Se este c¢digo for aberto no appbuilder, ap¢s salvo ser  necess rio abrir o fonte em 
no modo de edi‡Æo e remover as vari veis abaixo que vÆo ser inclu¡das autom ticamente.
Fazer um merge com o fonte que est  est  na rede e verificar o que foi inclu¡do 
autom ticamente e remover.*/

{include/i-estab-security.i}	 
&Scoped-define SEGUR-ESTAB-NOTFIND-MES FALSE

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/*DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.*/

def var i-numero-ordem like ordem-compra.numero-ordem no-undo.

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    
    {cxbo/bocx351.i tt-licenciam-import-oc}
&ENDIF


procedure setConstraint1:
end procedure. 

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then DO:
            &Scoped-define KEY-PHRASE TRUE NO-LOCK
            {include/i-estab-openquery.i}
        END.
        when 2 THEN DO:
            &Scoped-define KEY-PHRASE TRUE NO-LOCK use-index codigo
            {include/i-estab-openquery.i}
        END.
    end case.
    assign l-query    = true
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
/* {include/bosersen.i} */
{include/boprebro.i}
/* {include/boexecre.i} */
/* {include/boexeupt.i} */
/* {include/boexedel.i} */
/* {include/bovalupt.i} */
/* {include/bovaldel.i} */

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */

    run startMethod ("initializeValidade").

    run endMethod   ("initializeValidade").
end procedure.

procedure validateParametros:
    /*
    **
    */
    def input parameter p-data-ini    as char    no-undo.
    def input parameter p-data-fim    as char    no-undo.
    def input parameter p-est-ini     as char    no-undo.
    def input parameter p-est-fim     as char    no-undo.
    def input parameter p-proc-ini    as char    no-undo.
    def input parameter p-proc-fim    as char    no-undo.
    def input parameter p-exp-ini     as char format 'x(09)' no-undo.
    def input parameter p-exp-fim     as char format 'x(09)' no-undo.
    def input parameter p-itiner-ini  as char    no-undo.
    def input parameter p-itiner-fim  as char    no-undo.
    def input parameter p-pto-emb-ini as char    no-undo.
    def input parameter p-pto-emb-fim as char    no-undo.
    def input parameter p-pto-des-ini as char    no-undo.
    def input parameter p-pto-des-fim as char    no-undo.
    def input parameter p-local       as char    no-undo.
    def input parameter p-grupo-ini   as char    no-undo.
    def input parameter p-grupo-fim   as char    no-undo.
    def input parameter p-fam-ini     as char    no-undo.
    def input parameter p-fam-fim     as char    no-undo.
    def input parameter p-item-ini    as char    no-undo.
    def input parameter p-item-fim    as char    no-undo.
    def input parameter p-decl-ini    as char    no-undo.
    def input parameter p-decl-fim    as char    no-undo.

    &if "{&bf_cex_versao_ems}" >= "2.062" &then
       &if "{&bf_dis_versao_ems}" >= "2.04" &then
            def input parameter p-conhechouse-ini as char no-undo.
            def input parameter p-conhechouse-fim as char no-undo.
            def input parameter p-conhecmaster-ini as char no-undo.
            def input parameter p-conhecmaster-fim as char no-undo.
       &endif
    &else
        &if "{&bf_dis_versao_ems}" >= "2.05" &then
            def input parameter p-conhechouse-ini as char no-undo.
            def input parameter p-conhechouse-fim as char no-undo.
            def input parameter p-conhecmaster-ini as char no-undo.
            def input parameter p-conhecmaster-fim as char no-undo.
        &else
            def input parameter p-conhec-ini as char no-undo.
            def input parameter p-conhec-fim as char no-undo.
        &endif
    &endif    
    def input parameter p-fatura-ini  like invoice-emb-imp.nr-invoice no-undo.
    def input parameter p-fatura-fim  like invoice-emb-imp.nr-invoice no-undo.
    def input parameter p-embarque-ini  like embarque-imp.embarque no-undo.
    def input parameter p-embarque-fim  like embarque-imp.embarque no-undo.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        DEF INPUT PARAM c-veiculo-ini  AS CHAR NO-UNDO.
        DEF INPUT PARAM c-veiculo-fim  AS CHAR NO-UNDO.
        DEF INPUT PARAM dt-entrada-ini AS DATE NO-UNDO.
        DEF INPUT PARAM dt-entrada-fim AS DATE NO-UNDO.
    &endif

    def output parameter table for tt-bo-erro.

    def var i-teste as integer no-undo.

    if  p-est-ini > p-est-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm estabelec cod-estabel 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    if  p-data-ini > p-data-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Data_Chegada *}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    if  p-proc-ini > p-proc-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex processo-imp nr-proc-imp 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.


    assign i-teste = int(p-exp-ini) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-exp-ini = "0".
        {utp/ut-liter.i Fornecedor_inicial}       
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    assign i-teste = int(p-exp-fim) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-exp-fim = "0".
       {utp/ut-liter.i Fornecedor_final}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    if  int(p-exp-ini) > int(p-exp-fim) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Fornecedor *}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    assign i-teste = int(p-itiner-ini) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-itiner-ini = "0".
       {utp/ut-liter.i Itinerÿrio_inicial}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    assign i-teste = int(p-itiner-fim) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-itiner-fim = "0".
       {utp/ut-liter.i Itinerario_final}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    if  p-itiner-ini > p-itiner-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex processo-imp cod-itiner 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    assign i-teste = int(p-pto-emb-ini) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-pto-emb-ini = "0".
       {utp/ut-liter.i Pto_Emb_inicial}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    assign i-teste = int(p-pto-emb-fim) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-pto-emb-fim = "0".
       {utp/ut-liter.i Pto_Emb_final}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    if  p-pto-emb-ini > p-pto-emb-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex itinerario pto-embarque 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    assign i-teste = int(p-pto-des-ini) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-pto-des-ini = "0".
       {utp/ut-liter.i Pto_Desemb_inicial}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    assign i-teste = int(p-pto-des-fim) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-pto-emb-fim = "0".
       {utp/ut-liter.i Pto_Desemb_final}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    if  p-pto-des-ini > p-pto-des-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex itinerario pto-desembarque 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    assign i-teste = int(p-grupo-ini) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-grupo-ini = "0".
       {utp/ut-liter.i Grupo_Est_inicial}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    assign i-teste = int(p-grupo-fim) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-grupo-fim = "0".
       {utp/ut-liter.i Grupo_Est_final}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    if  p-grupo-ini > p-grupo-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind item ge-codigo 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    if  p-fam-ini > p-fam-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind item fm-codigo 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    if  p-item-ini > p-item-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind item it-codigo 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    if  p-decl-ini > p-decl-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex embarque-imp declaracao-import 1}
        /* inicial maior que final */
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    &if "{&bf_cex_versao_ems}" >= "2.062" &then
       &if "{&bf_dis_versao_ems}" >= "2.04" &then
            if  p-conhechouse-ini > p-conhechouse-fim then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgind item it-codigo 1}
                /* inicial maior que final */
                run utp/ut-msgs.p (input "msg",
                                   input 142,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 142
                       tt-bo-erro.mensagem = return-value.
            end.

            if  p-conhecmaster-ini > p-conhecmaster-fim then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgind item it-codigo 1}
                /* inicial maior que final */
                run utp/ut-msgs.p (input "msg",
                                   input 142,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 142
                       tt-bo-erro.mensagem = return-value.
            end.
       &endif
    &else
        &if "{&bf_dis_versao_ems}" >= "2.05" &then
            if  p-conhechouse-ini > p-conhechouse-fim then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgind item it-codigo 1}
                /* inicial maior que final */
                run utp/ut-msgs.p (input "msg",
                                   input 142,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 142
                       tt-bo-erro.mensagem = return-value.
            end.

            if  p-conhecmaster-ini > p-conhecmaster-fim then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgind item it-codigo 1}
                /* inicial maior que final */
                run utp/ut-msgs.p (input "msg",
                                   input 142,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 142
                       tt-bo-erro.mensagem = return-value.
            end.
        &else
            if  p-conhec-ini > p-conhec-fim then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgind item it-codigo 1}
                /* inicial maior que final */
                run utp/ut-msgs.p (input "msg",
                                   input 142,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 142
                       tt-bo-erro.mensagem = return-value.
            end.
        &endif
    &endif

    assign i-teste = int(p-local) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               p-local = "0".
       {utp/ut-liter.i Localiza‡Æo}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.
    if p-local <> "0" then do:
       if not can-find(first pto-itiner where 
                       pto-itiner.cod-pto-contr = int(p-local)) then do:
          assign i-seq-erro = i-seq-erro + 1.
         {utp/ut-table.i mgcex pto-contr 1}
          run utp/ut-msgs.p (input "msg",
                             input 2,
                            input return-value).
          create tt-bo-erro.
          assign tt-bo-erro.i-sequen = i-seq-erro
                 tt-bo-erro.cd-erro  = 2
                 tt-bo-erro.mensagem = return-value.
       end.
    end.

    if p-fatura-ini > p-fatura-fim then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex invoice-emb-imp nr-invoice 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.    
        run utp/ut-msgs.p (input "msg",
                           input 142,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 142
               tt-bo-erro.mensagem = return-value.
    end.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
        IF param-global.log-modul-eq = yes THEN DO:
            IF c-veiculo-ini > c-veiculo-fim THEN DO:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i movdis eq-embarq-praz-compra cod-placa 1}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.    
                run utp/ut-msgs.p (input "msg",
                                   input 142,
                                   input return-value).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 142
                       tt-bo-erro.mensagem = return-value.
            END.

            IF dt-entrada-ini > dt-entrada-fim THEN DO:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i movdis eq-embarq-praz-compra dat-entr 1}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.    
                run utp/ut-msgs.p (input "msg",
                                   input 142,
                                   input return-value).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 142
                       tt-bo-erro.mensagem = return-value.
            END.
        END.
    &endif

end procedure. /* validateParametros */

procedure serverSendRows:
    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
    define input  parameter piStartRow     as  integer   no-undo.
    define input  parameter pcRowIdent     as  character no-undo.
    define input  parameter plNext         as  logical   no-undo.
    define input  parameter piRowsToReturn as  integer   no-undo.
    define output parameter piRowsReturned as  integer   no-undo.
    define output parameter table          for RowObject.

    define variable hQuery        as handle    no-undo.
    define variable hBuffer       as handle    no-undo.
    define variable hRowObject    as handle    no-undo.
    define variable hDataQuery    as handle    no-undo.
    define variable cRowIdent     as character no-undo.
    define variable rRowIDs       as rowid     extent 10 no-undo.
    define variable lOK           as logical   no-undo.
    define variable iRow          as integer   no-undo.

    for each rowObject:
        delete rowObject.
    end.
    IF true THEN DO:
        IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN DO:
            rRowIDs = ?.
            reposition {&query-name} to rowid to-rowid(pcRowIdent).
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow.

            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE true:
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:
                create rowObject.
		  buffer-copy {&table-name} to rowObject.
		  assign rowObject.r-rowid = {&table-name}.r-rowid.
                GET NEXT {&query-name}.
                piRowsReturned = piRowsReturned + 1.
            end.
            else
                leave.
        END.
        IF piRowsReturned > 0 THEN DO:
            {&open-query}
            IF piStartRow = ? OR piStartRow = 0 THEN DO:
                get first {&query-name}.
                get prev {&query-name}.
            END.
            ELSE
                REPOSITION  {&query-name} TO ROW (piStartRow).
        END.
    END.
    RETURN.
end procedure.

procedure filtrarEmbarqueordem:
/*
** Filtra embarques conforme ordem de compra selecionada
*/
def input parameter p-rowid as rowid no-undo.

find ordem-compra where rowid(ordem-compra) = p-rowid no-lock no-error.
if avail ordem-compra then do:
    for each ordens-embarque where ordens-embarque.numero-ordem = ordem-compra.numero-ordem no-lock:
        for each rowObject:
            if rowObject.embarque = ordens-embarque.embarque then DO:
                /******************************************************************************************
                ** TECNICA SEGURANCA ESTABELECIMENTO
                ******************************************************************************************/
                IF l-estab-security-active = TRUE THEN DO:
                	FIND FIRST {&ESTAB-SEC-TT} NO-LOCK
                		WHERE {&ESTAB-SEC-TT-FIELD} = ordens-embarque.cod-estabel NO-ERROR.
                	IF AVAIL {&ESTAB-SEC-TT} THEN
                		NEXT.
                END.
                ELSE
                    NEXT.
                /******************************************************************************************
                ** TECNICA SEGURANCA ESTABELECIMENTO
                ******************************************************************************************/                
            END.
            delete rowObject.
        end.
    end.
end.

end procedure.

procedure filtrarEmbarquepedido:
/*
** Filtra embarques conforme pedido selecionado
*/
def input parameter p-rowid as rowid no-undo.

find pedido-compr where rowid(pedido-compr) = p-rowid no-lock no-error.
if avail pedido-compr then do:
    for each ordem-compra where ordem-compra.num-pedido = pedido-compr.num-pedido no-lock:
        for each ordens-embarque where ordens-embarque.numero-ordem = ordem-compra.numero-ordem no-lock:
            for each rowObject:
                if rowObject.embarque = ordens-embarque.embarque then DO:
                    /******************************************************************************************
                    ** TECNICA SEGURANCA ESTABELECIMENTO
                    ******************************************************************************************/
                    IF l-estab-security-active = TRUE THEN DO:
                    	FIND FIRST {&ESTAB-SEC-TT} NO-LOCK
                    		WHERE {&ESTAB-SEC-TT-FIELD} = ordens-embarque.cod-estabel NO-ERROR.
                    	IF AVAIL {&ESTAB-SEC-TT} THEN
                    		NEXT.
                    END.
                    ELSE
                        NEXT.
                    /******************************************************************************************
                    ** TECNICA SEGURANCA ESTABELECIMENTO
                    ******************************************************************************************/                
                END.
                delete rowObject.
            end.
        end.
    end.
end.

end procedure.

procedure criarTTEmbarque:
/*
** Criar temp-table com os registros filtrados
**
** Mesma rotina utilizada para impressÆo do relatorio IM0655 - Listagem Posi‡Æo Embarques
*/
def input parameter p-atraso      as integer no-undo.
def input parameter p-situacao    as integer no-undo.
def input parameter p-sit-emb     as integer no-undo.
def input parameter p-local       as integer no-undo.
def input parameter p-data-ini    like historico-embarque.dt-efetiva no-undo.
def input parameter p-data-fim    like historico-embarque.dt-efetiva no-undo.
def input parameter p-est-ini     like estabelec.cod-estabel no-undo.
def input parameter p-est-fim     like estabelec.cod-estabel no-undo.
def input parameter p-proc-ini    like processo-imp.nr-proc-imp no-undo.
def input parameter p-proc-fim    like processo-imp.nr-proc-imp no-undo.
def input parameter p-exp-ini     like emitente.cod-emitente no-undo.
def input parameter p-exp-fim     like emitente.cod-emitente no-undo.
def input parameter p-itiner-ini  like itinerario.cod-itiner no-undo.
def input parameter p-itiner-fim  like itinerario.cod-itiner no-undo.
def input parameter p-pto-emb-ini like pto-contr.cod-pto-contr no-undo.
def input parameter p-pto-emb-fim like pto-contr.cod-pto-contr no-undo.
def input parameter p-pto-des-ini like pto-contr.cod-pto-contr no-undo.
def input parameter p-pto-des-fim like pto-contr.cod-pto-contr no-undo.
def input parameter p-grupo-ini   like grup-estoque.ge-codigo no-undo.
def input parameter p-grupo-fim   like grup-estoque.ge-codigo no-undo.
def input parameter p-fam-ini     like familia.fm-codigo no-undo.
def input parameter p-fam-fim     like familia.fm-codigo no-undo.
def input parameter p-item-ini    like item.it-codigo no-undo.
def input parameter p-item-fim    like item.it-codigo no-undo.
def input parameter p-decl-ini    like embarque-imp.declaracao-import no-undo.
def input parameter p-decl-fim    like embarque-imp.declaracao-import no-undo.

&if "{&bf_cex_versao_ems}" >= "2.062" &then
   &if "{&bf_dis_versao_ems}" >= "2.04" &then
        def input parameter p-conhechouse-ini like embarque-imp.cod-conhecto-house no-undo.
        def input parameter p-conhechouse-fim like embarque-imp.cod-conhecto-house no-undo.
        def input parameter p-conhecmaster-ini like embarque-imp.cod-conhecto-master no-undo.
        def input parameter p-conhecmaster-fim like embarque-imp.cod-conhecto-master no-undo.
   &endif
&else
    &if "{&bf_dis_versao_ems}" >= "2.05" &then
        def input parameter p-conhechouse-ini like embarque-imp.cod-conhecto-house no-undo.
        def input parameter p-conhechouse-fim like embarque-imp.cod-conhecto-house no-undo.
        def input parameter p-conhecmaster-ini like embarque-imp.cod-conhecto-master no-undo.
        def input parameter p-conhecmaster-fim like embarque-imp.cod-conhecto-master no-undo.
    &else
        def input parameter p-conhec-ini  like embarque-imp.nr-conhecimento no-undo.
        def input parameter p-conhec-fim  like embarque-imp.nr-conhecimento no-undo.
    &endif
&endif   

def input parameter p-fatura-ini  like invoice-emb-imp.nr-invoice no-undo.
def input parameter p-fatura-fim  like invoice-emb-imp.nr-invoice no-undo.
def input parameter p-embarque-ini like embarque-imp.embarque no-undo.
def input parameter p-embarque-fim like embarque-imp.embarque no-undo.
def input parameter p-veiculo-transp-ini as char no-undo.
def input parameter p-veiculo-transp-fim as char no-undo.
&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
    DEFINE INPUT PARAMETER pPtoSolicLiIni   LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
    DEFINE INPUT PARAMETER pPtoSolicLiFim   LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
    DEFINE INPUT PARAMETER pLicencImportIni LIKE licenciam-import-oc.licenca-import        NO-UNDO. 
    DEFINE INPUT PARAMETER pLicencImportFim LIKE licenciam-import-oc.licenca-import        NO-UNDO. 
    DEF INPUT PARAM c-veiculo-ini  AS CHAR NO-UNDO.
    DEF INPUT PARAM c-veiculo-fim  AS CHAR NO-UNDO.
    DEF INPUT PARAM dt-entrada-ini AS DATE NO-UNDO.
    DEF INPUT PARAM dt-entrada-fim AS DATE NO-UNDO.

    DEFINE VARIABLE i-pto-solic-li    LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
&ENDIF

def var i-cod-itiner  like itinerario.cod-itiner   no-undo.       
def var i-pto-chegada like pto-contr.cod-pto-contr no-undo.
def var l-ok          as logical                   no-undo. 
DEF VAR l-sem-faixa   AS LOGICAL                   NO-UNDO.

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    
    DEFINE VARIABLE h-bocx351 AS HANDLE NO-UNDO.
    IF NOT VALID-HANDLE(h-bocx351) THEN
        RUN cxbo/bocx351.p PERSISTENT SET h-bocx351.
&ENDIF


    for each tt-historico:
        delete tt-historico.
    end.      

    for each tt-historico-tmp:
        delete tt-historico-tmp.
    end.        

    ASSIGN l-sem-faixa = NO.

    IF  p-est-ini              = ""                     AND
        p-est-fim              = "ZZZ"                  and
        p-proc-ini             = ""                     and
        p-proc-fim             = "ZZZZZZZZZZZZ"         and
        p-exp-ini              = 0                      and
        p-exp-fim              = 999999999              and
        p-itiner-ini           = 0                      and
        p-itiner-fim           = 99999                  and
        p-pto-emb-ini          = 0                      and
        p-pto-emb-fim          = 99999                  and
        p-pto-des-ini          = 0                      and
        p-pto-des-fim          = 99999                  and
        p-grupo-ini            = 0                      and
        p-grupo-fim            = 99                     and
        p-fam-ini              = ""                     and  
        p-fam-fim              = "ZZZZZZZZ"             and 
        p-item-ini             = ""                     and
        p-item-fim             = "ZZZZZZZZZZZZZZZZ"     and
        p-fatura-ini           = ""                     and
        p-fatura-fim           = "ZZZZZZZZZZZZ"         and
        p-embarque-ini         = ""                     and   
        p-embarque-fim         = "ZZZZZZZZZZZZZZZZ"     and
        p-decl-ini             = ""                     and
        p-decl-fim             = "ZZZZZZZZZZZZZZZZZZZZ" and
        p-veiculo-transp-ini   = ""                     AND
        p-veiculo-transp-fim   = "ZZZZZZZZZZZZZZZZZZZZ" AND
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN     
            c-veiculo-ini     = ""                      AND
            c-veiculo-fim     = "ZZZZZZZZZZZZ"          AND
            dt-entrada-ini    = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001  &ENDIF              AND
            dt-entrada-fim    = 12/31/9999              AND
            pPtoSolicLiIni    = 0                       AND
            pPtoSolicLiFim    = 99999                   AND
            pLicencImportIni  = ""                      AND
            pLicencImportFim  = "ZZZZZZZZZZZZZZZZZZZZ"  AND
        &ENDIF
        &if "{&bf_cex_versao_ems}" >= "2.062" &then
           &if "{&bf_dis_versao_ems}" >= "2.04" &then
                p-conhechouse-ini = "" and
                p-conhechouse-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ" and
                p-conhecmaster-ini = "" and
                p-conhecmaster-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
           &endif
        &else
            &IF DEFINED(BF-MAT-COMEX) &THEN
                &if "{&bf_dis_versao_ems}" >= "2.05" &then
                    p-conhechouse-ini = "" and
                    p-conhechouse-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ" AND
                    p-conhecmaster-ini = "" and
                    p-conhecmaster-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                &else
                    p-conhec-ini = "" and
                    p-conhec-fim = "ZZZZZZZZZZZZZZZZZZ" 
                &endif
            &ELSE
                &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN  
                    &IF {&BF_DIS_VERSAO_EMS} < 2.04 &THEN
                        &IF "{&ems_dbtype}" <> "progress":U &THEN
                            p-conhec-ini = "" and
                            p-conhec-fim = "ZZZZZZZZZZZZZZZZZZ" 
                        &ELSE
                            p-conhec-ini = "" and
                            p-conhec-fim = "ZZZZZZZZZZZZZZZ" 
                        &ENDIF       
                    &ELSE
                        &if "{&bf_dis_versao_ems}" >= "2.05" &then
                            p-conhechouse-ini = "" and
                            p-conhechouse-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ" and
                            p-conhecmaster-ini = "" and
                            p-conhecmaster-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                        &else
                            p-conhec-ini = "" and
                            p-conhec-fim = "ZZZZZZZZZZZZZZZZZZ" 
                        &endif
                    &ENDIF
                &ELSE
                    &if "{&bf_dis_versao_ems}" >= "2.05" &then
                        p-conhechouse-ini = "" and
                        p-conhechouse-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ" and
                        p-conhecmaster-ini = "" and
                        p-conhecmaster-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                    &else
                        p-conhec-ini = "" and
                        p-conhec-fim = "ZZZZZZZZZZZZZZZZZZ" 
                    &endif
                &ENDIF
            &endif
        &ENDIF 
        THEN DO:
        ASSIGN l-sem-faixa = YES.
    END.

    /* Embarque */
    bloco_emb:
    FOR EACH embarque-imp WHERE
             embarque-imp.cod-estabel >= p-est-ini AND
             embarque-imp.cod-estabel <= p-est-fim AND
             embarque-imp.embarque    >= p-embarque-ini AND
             embarque-imp.embarque    <= p-embarque-fim NO-LOCK:

        /******************************************************************************************
        ** TECNICA SEGURANCA ESTABELECIMENTO
        ******************************************************************************************/
        IF l-estab-security-active = TRUE THEN DO:
        	FIND FIRST {&ESTAB-SEC-TT} NO-LOCK
        		WHERE {&ESTAB-SEC-TT-FIELD} = embarque-imp.cod-estabel NO-ERROR.
        	IF NOT AVAIL {&ESTAB-SEC-TT} THEN
        		NEXT.
        END.
        /******************************************************************************************
        ** TECNICA SEGURANCA ESTABELECIMENTO
        ******************************************************************************************/

        ASSIGN l-ok = YES.

        IF p-sit-emb <> 3 THEN /* situa‡Æo "3" ‚ todos */
            IF embarque-imp.situacao <> p-sit-emb
                THEN NEXT.

        if  p-fatura-ini <> "" or
            p-fatura-fim <> "zzzzzzzzzzzz" then 
            if  not can-find(first invoice-emb-imp where
                invoice-emb-imp.embarque = embarque-imp.embarque and
                invoice-emb-imp.nr-invoice >= p-fatura-ini and
                invoice-emb-imp.nr-invoice <= p-fatura-fim) then
                next.    
        IF    
        &if "{&bf_cex_versao_ems}" >= "2.062" &then
           &if "{&bf_dis_versao_ems}" >= "2.04" &then
                p-conhechouse-ini  <> "" or
                p-conhechouse-fim  <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ" or
                p-conhecmaster-ini <> "" or
                p-conhecmaster-fim <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
           &endif
        &ELSE
            &IF DEFINED(BF-MAT-COMEX) &THEN
                &if "{&bf_dis_versao_ems}" >= "2.05" &then
                    p-conhechouse-ini  <> "" OR
                    p-conhechouse-fim  <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ" OR
                    p-conhecmaster-ini <> "" OR
                    p-conhecmaster-fim <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                &else
                    p-conhec-ini <> "" OR
                    p-conhec-fim <> "ZZZZZZZZZZZZZZZZZZ" 
                &endif
            &ELSE
                &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN  
                    &IF {&BF_DIS_VERSAO_EMS} < 2.04 &THEN
                        &IF "{&ems_dbtype}" <> "progress":U &THEN
                            p-conhec-ini <> "" OR
                            p-conhec-fim <> "ZZZZZZZZZZZZZZZZZZ" 
                        &ELSE
                            p-conhec-ini <> "" OR
                            p-conhec-fim <> "ZZZZZZZZZZZZZZZ" 
                        &ENDIF
                    &ELSE
                        &if "{&bf_dis_versao_ems}" >= "2.05" &then
                            p-conhechouse-ini  <> "" or
                            p-conhechouse-fim  <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ" or
                            p-conhecmaster-ini <> "" or
                            p-conhecmaster-fim <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                        &else
                            p-conhec-ini <> "" or
                            p-conhec-fim <> "ZZZZZZZZZZZZZZZZZZ" 
                        &endif
                    &ENDIF
                &ELSE
                    &if "{&bf_dis_versao_ems}" >= "2.05" &then
                        p-conhechouse-ini  <> "" or
                        p-conhechouse-fim  <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ" or
                        p-conhecmaster-ini <> "" or
                        p-conhecmaster-fim <> "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                    &else
                        p-conhec-ini <> "" OR
                        p-conhec-fim <> "ZZZZZZZZZZZZZZZZZZ" 
                    &endif
                &ENDIF  
            &ENDIF 
        &endif    
        then do:

        &if "{&bf_cex_versao_ems}" >= "2.062" &then
           &if "{&bf_dis_versao_ems}" >= "2.04" &then
                if embarque-imp.cod-conhecto-house < p-conhechouse-ini or
                   embarque-imp.cod-conhecto-house > p-conhechouse-fim then
                    next.
                if embarque-imp.cod-conhecto-master < p-conhecmaster-ini or
                   embarque-imp.cod-conhecto-master > p-conhecmaster-fim then
                   next.
           &endif
        &else
           &if "{&bf_dis_versao_ems}" >= "2.05" &then
                if embarque-imp.cod-conhecto-house < p-conhechouse-ini or
                   embarque-imp.cod-conhecto-house > p-conhechouse-fim then
                    next.
                if embarque-imp.cod-conhecto-master < p-conhecmaster-ini or
                   embarque-imp.cod-conhecto-master > p-conhecmaster-fim then
                   next.
           &else
                if embarque-imp.nr-conhecimento < p-conhec-ini or
                   embarque-imp.nr-conhecimento > p-conhec-fim then
                   next.
           &endif
        &endif   
        end.

        if  p-decl-ini <> "" or
            p-decl-fim <> "ZZZZZZZZZZZZZZZZZZZZ" then
            if embarque-imp.declaracao-import < p-decl-ini or
               embarque-imp.declaracao-import > p-decl-fim then
                next.

        if  p-veiculo-transp-ini <> "" or
            p-veiculo-transp-fim <> "ZZZZZZZZZZZZZZZZZZZZ" then
            if substr(embarque-imp.char-1,1,20) < p-veiculo-transp-ini or
               substr(embarque-imp.char-1,1,20) > p-veiculo-transp-fim then
               next.

        /* Historico */
        find last historico-embarque 
            where historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
                  historico-embarque.embarque      = embarque-imp.embarque
                  no-lock no-error.

        if not avail historico-embarque then next.

        /* Processos */                  
        if p-atraso = 1 then /* atrasados */
            if historico-embarque.dt-ult-previsao <= historico-embarque.dt-previsao then next.
        if p-atraso = 2 then /* adiantados */
            if historico-embarque.dt-ult-previsao >= historico-embarque.dt-previsao then next.        

        /* Itinerario */
        if historico-embarque.cod-itiner < p-itiner-ini or
           historico-embarque.cod-itiner > p-itiner-fim
            then next.

        find itinerario where itinerario.cod-itiner = historico-embarque.cod-itiner no-lock no-error.
        if not avail itinerario then next.
        else do:    
            assign i-cod-itiner  = itinerario.cod-itiner
                   i-pto-chegada = embarque-imp.cdn-pto-chegad
                   &if "{&BF_MAT_VERSAO_EMS}":U >= "2.062":U &then
                   i-pto-solic-li = itinerario.cdn-pto-solic-licenciam-import
                   &endif.

            if  embarque-imp.cdn-pto-embarq < p-pto-emb-ini 
            or  embarque-imp.cdn-pto-embarq > p-pto-emb-fim then
                next.

            if  embarque-imp.cdn-pto-desembar < p-pto-des-ini 
            or  embarque-imp.cdn-pto-desembar > p-pto-des-fim then 
                next.

            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN     

                if  pPtoSolicLiIni <> 0  
                or  pPtoSolicLiFim <> 99999 then do:

                    if  itinerario.cdn-pto-solic-licenciam-import < pPtoSolicLiIni 
                    or  itinerario.cdn-pto-solic-licenciam-import > pPtoSolicLiFim then
                        next.
                end.

            &ENDIF
        end.

        &IF "{&BF_MAT_VERSAO_EMS}":U >= "2.062":U &THEN

        for first historico-embarque 
            where historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
            and   historico-embarque.embarque      = embarque-imp.embarque 
            and   historico-embarque.cod-itiner    = i-cod-itiner 
            and   historico-embarque.cod-pto-contr = i-pto-solic-li no-lock: end.
        if  not avail historico-embarque then do:

            assign i-pto-solic-li = 0.

            if  pPtoSolicLiIni <> 0
            or  pPtoSolicLiFim <> 99999 then 
                next.
        end.

        &ENDIF 


        if p-local <> 0 then
            find historico-embarque
                where historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
                      historico-embarque.embarque      = embarque-imp.embarque and 
                      historico-embarque.cod-itiner    = i-cod-itiner and
                      historico-embarque.cod-pto-contr = p-local              
                      no-lock no-error.
        else do:
            find historico-embarque
                where historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
                      historico-embarque.embarque      = embarque-imp.embarque and 
                      historico-embarque.cod-itiner    = i-cod-itiner and
                      historico-embarque.cod-pto-contr = i-pto-chegada
                      no-lock no-error.
        end.

        if p-item-ini <> "" or 
           p-item-fim <> "zzzzzzzzzzzzzzzz" or 
           p-proc-ini <> "" or 
           p-proc-fim <> "zzzzzzzzzzzz" then
           assign l-ok = no.           

        IF l-sem-faixa = NO THEN DO:
            for first ordens-embarque no-lock 
                where ordens-embarque.cod-estabel = embarque-imp.cod-estabel and
                      ordens-embarque.embarque    = embarque-imp.embarque: end.

            if not avail ordens-embarque then next.    
        END.


        for each  ordens-embarque no-lock 
            where ordens-embarque.cod-estabel = embarque-imp.cod-estabel AND
                  ordens-embarque.embarque    = embarque-imp.embarque: 

            if ordens-embarque.nr-proc-imp < p-proc-ini or
               ordens-embarque.nr-proc-imp > p-proc-fim then next.

            find ordem-compra where 
                 ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock no-error.
            if not avail ordem-compra then do:
               assign l-ok = no.
               LEAVE.
            end. 

            /*
            Fun»’o no momento desativada conforme FO 1630.707/FO atual 1993.265
            &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            FIND FIRST param-global NO-LOCK NO-ERROR.
            IF param-global.log-modul-eq THEN DO: 

                FOR FIRST eq-param-embarq FIELDS(idi-veic)
                     WHERE eq-param-embarq.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.

                IF AVAIL eq-param-embarq THEN do:

                     FOR FIRST eq-embarq-praz-compra NO-LOCK WHERE
                               eq-embarq-praz-compra.cod-estabel   = ordens-embarque.cod-estabel AND 
                               eq-embarq-praz-compra.numero-ordem  = ordem-compra.numero-ordem.
                     END.
                     IF AVAIL eq-embarq-praz-compra THEN DO:
                         IF eq-param-embarq.idi-veic = 1 THEN DO:
                             IF eq-embarq-praz-compra.cod-placa    < c-veiculo-ini   AND
                                eq-embarq-praz-compra.cod-placa    > c-veiculo-fim   AND
                                eq-embarq-praz-compra.dat-entr     < dt-entrada-ini  AND
                                eq-embarq-praz-compra.dat-entr     > dt-entrada-fim  THEN DO:

                                  ASSIGN l-ok = NO.
                                  NEXT.
                             END.
                         END.
                         ELSE DO:
                               IF eq-embarq-praz-compra.dat-ent      < dt-entrada-ini  AND
                                  eq-embarq-praz-compra.dat-ent      > dt-entrada-fim  AND
                                  NOT CAN-FIND(FIRST eq-veic WHERE eq-veic.cod-placa   = eq-embarq-praz-compra.cod-placa AND
                                                                   eq-veic.cod-chassi >=  c-veiculo-ini  AND
                                                                   eq-veic.cod-chassi <=  c-veiculo-fim) THEN DO:
                                     ASSIGN l-ok = NO.
                                     NEXT.
                               END.
                         END.
                     END.
                     ELSE DO:
                         IF c-veiculo-ini <> "" OR
                            c-veiculo-fim <> "ZZZZZZZZZZZZ" OR
                            dt-entrada-ini <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF  OR
                            dt-entrada-fim <> 12/31/9999 THEN DO:
                             ASSIGN l-ok = NO.
                             NEXT.
                         END.
                     END.
                END.
            END.
            &endif*/

            if i-numero-ordem <> 0 then 
                if ordem-compra.numero-ordem <> i-numero-ordem then do:
                   ASSIGN l-ok = NO.
                   NEXT.
                END.

            if ordem-compra.cod-emitente < p-exp-ini or 
               ordem-compra.cod-emitente > p-exp-fim then do:
               assign l-ok = no.
               NEXT. 
            end.

            if ordem-compra.it-codigo < p-item-ini or
               ordem-compra.it-codigo > p-item-fim then do:
               assign l-ok = no.
               NEXT. 
            end.

            find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
            if not avail item then do:
               assign l-ok = no.
               NEXT. 
            end.   

            IF p-grupo-ini <> 0  OR
               p-grupo-fim <> 99 THEN DO:
               if item.ge-codigo < p-grupo-ini or
                  item.ge-codigo > p-grupo-fim then DO:
                  ASSIGN l-ok = NO.
                  NEXT.
               END.
            END.
            IF p-fam-ini <> "" OR
               p-fam-fim <> "ZZZZZZZZ" THEN DO:
               if item.fm-codigo < p-fam-ini or
                  item.fm-codigo > p-fam-fim then do:
                  ASSIGN l-ok = NO.
                  NEXT.
               end.
            END.

            find first processo-imp 
                 where processo-imp.num-pedido = ordem-compra.num-pedido  no-lock no-error.
            if not avail processo-imp then do:
               assign l-ok = no.
               leave. 
            end.
            if p-situacao <> 5 then
                if processo-imp.situacao <> p-situacao then do: 
                    ASSIGN l-ok = NO.                        
                    NEXT.
                END.     

            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN     
                IF pLicencImportIni <> "" 
                OR pLicencImportFim <> "ZZZZZZZZZZZZZZZZZZZZ" THEN DO:
                    RUN piRetornaLi IN h-bocx351(INPUT 3,
                                                 INPUT YES,
                                                 INPUT ?,
                                                 INPUT ?,
                                                 INPUT ?,
                                                 INPUT ordens-embarque.parcela,
                                                 INPUT YES,
                                                 INPUT YES,
                                                 INPUT ordens-embarque.numero-ordem,
                                                 INPUT ordens-embarque.numero-ordem,
                                                 INPUT "",
                                                 INPUT "",
                                                 INPUT "",
                                                 INPUT "",
                                                 INPUT "",
                                                 INPUT "",
                                                 OUTPUT TABLE tt-licenciam-import-oc).
                    FIND FIRST tt-licenciam-import-oc
                        WHERE tt-licenciam-import-oc.licenca-import >= pLicencImportIni
                        AND   tt-licenciam-import-oc.licenca-import <= pLicencImportFim NO-ERROR.
                    IF NOT AVAIL tt-licenciam-import-oc THEN DO:
                        ASSIGN l-ok = NO.                        
                        NEXT.
                    END.     
                END.
            &ENDIF

            assign l-ok = yes.

            leave.

        end.

        if l-ok = no then next.

        if avail historico-embarque then do:

           if historico-embarque.dt-efetiva <> ? then do:
              if historico-embarque.dt-efetiva < p-data-ini or
                 historico-embarque.dt-efetiva > p-data-fim then
                 next.
              end.                
           else 
           if historico-embarque.dt-ult-previsao <> ? then do:
              if historico-embarque.dt-ult-previsao < p-data-ini or
                 historico-embarque.dt-ult-previsao > p-data-fim then
                 next.
           end.           

           create tt-historico-tmp.
           buffer-copy historico-embarque to tt-historico-tmp.
           assign tt-historico-tmp.r-rowid     = rowid(historico-embarque)   
                  tt-historico-tmp.dt-efetiva  = historico-embarque.dt-efetiva
                  tt-historico-tmp.dt-ult-previsao = historico-embarque.dt-ult-previsao.
        end.
        else 
           next.          

        create tt-historico.
        buffer-copy tt-historico-tmp to tt-historico.

    end.
    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    
        IF VALID-HANDLE(h-bocx351) THEN
            DELETE PROCEDURE h-bocx351.  
    &ENDIF

end procedure.

PROCEDURE retornaTThistorico:

    def output parameter table for tt-historico.
    &Scoped-define KEY-PHRASE TRUE NO-LOCK
    {include/i-estab-openquery.i}

END PROCEDURE.


procedure criarTTembarqueaux:
/*
** Executado quando a consulta parte do m¢dulo de compras ("CC0505 - Consulta Ordens de Compra")
*/
def input parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.

assign i-numero-ordem = p-numero-ordem.

end procedure.
