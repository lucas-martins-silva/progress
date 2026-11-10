/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD268 2.00.00.037 } /*** "010037" 10/06/2025 09:30:37  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad268 MUT}
&ENDIF

/*
**  BOAD268.P
**
**  transporte - Transportadores
**
**  Ultima alteraá∆o : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY transporte
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME transporte
 
{include/boini.i}
 
{cdp/cdcfgdis.i} /* Include uso de pre-processadores para modulo BN*/

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

{adbo/boad268.i RowObject}

&IF '{&BF_DIS_VERSAO_EMS}' >= '2.02' AND "{&mguni_version}" < "2.07" &THEN
    {scbo/bosc025.i tt-imp-transp}
&ENDIF

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.


 define buffer b-estab      for estab-cli.
 define buffer b-nota       for nota-fiscal.
 define buffer b-ped        for ped-venda.
 define buffer b-emitente   for emitente.
 define buffer b-imag-for   for imag-for.
 define buffer b-ender-red  for ender-red.
 define buffer b-embarque   for embarque.
 define buffer b-pre-fatur  for pre-fatur.
 define buffer b-remito     for remito.
 define buffer b-doc-fiscal for doc-fiscal.
 define buffer b-loc-entr   for loc-entr.
 define buffer b-simul-emb  for simul-emb.

 def var c-cod-trans-ini  as int  no-undo.
 def var c-cod-trans-fim  as int  no-undo.
 def var c-nome-trans-ini as char no-undo.
 def var c-nome-trans-fim as char no-undo.
 def var h-bosc025        as handle no-undo.
 def var v-nome-abrev     as char no-undo.
 
procedure setConstraint1:
 def input param p-cod-inicial  as char no-undo.
 def input param p-cod-final    as char no-undo. 
 def input param p-nome-inicial as char no-undo.
 def input param p-nome-final   as char no-undo.
 
 assign c-cod-trans-ini  = integer(p-cod-inicial)
        c-cod-trans-fim  = integer(p-cod-final)
        c-nome-trans-ini = p-nome-inicial
        c-nome-trans-fim = p-nome-final.
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-transp >= c-cod-trans-ini and
                                                                  {&TABLE-NAME}.cod-transp <= c-cod-trans-fim and
                                                                  {&TABLE-NAME}.nome-abrev >= c-nome-trans-ini and
                                                                  {&TABLE-NAME}.nome-abrev <= c-nome-trans-fim no-lock by cod-transp INDEXED-REPOSITION.  
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-transp >= c-cod-trans-ini and
                                                                  {&TABLE-NAME}.cod-transp <= c-cod-trans-fim and
                                                                  {&TABLE-NAME}.nome-abrev >= c-nome-trans-ini and
                                                                  {&TABLE-NAME}.nome-abrev <= c-nome-trans-fim no-lock by nome-abrev INDEXED-REPOSITION.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.

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
/* {include/boexecre.i} */  /* metodos create/delete customizados */
{include/boexeupt.i}
/* {include/boexedel.i} */
{include/bovalupt.i}
/*{include/bovaldel.i}*/
 
procedure executeCreate:
    /*
    **  Cria registro na tabela.
    */
 
    create {&TABLE-NAME}.
    buffer-copy RowObject except r-rowid {1} to {&TABLE-NAME}.
    return string(rowid({&TABLE-NAME})).

    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.02' AND "{&mguni_version}" < "2.07" &THEN
    find first param-global no-lock no-error.
    if avail param-global then do:

        &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN 
            if param-global.modulo-tf = yes then do:
        &ELSE
            if param-global.int-2 = 1 then do:
        &ENDIF
                find first emitente
                    where emitente.cod-emitente = RowObject.cod-emitente
                    no-lock no-error.

                create tt-imp-transp.
                assign tt-imp-transp.nome-transp      = RowObject.nome-abrev
                       tt-imp-transp.nome             = RowObject.nome
                       tt-imp-transp.cgc              = RowObject.cgc
                       tt-imp-transp.nome-abrev-emit  = if avail emitente
                                                        then emitente.nome-abrev
                                                        else ""
                       tt-imp-transp.cod-emitente     = RowObject.cod-emitente
                       tt-imp-transp.log-ativo        = yes.
        
                if not valid-handle(h-bosc025) then
                    run scbo/bosc025.p persistent set h-bosc025.
        
                run setRecord in h-bosc025 (input table tt-imp-transp).
                run createRecord in h-bosc025.

                IF VALID-HANDLE(h-bosc025) THEN DO:
                    DELETE PROCEDURE h-bosc025.
                    ASSIGN h-bosc025 = ?.
                END.
            end.
    end. /* avail param-global */
    &ENDIF

end procedure.


procedure executeUpd:
    /*
    **  Cria registro na tabela.
    */

    FIND FIRST {&TABLE-NAME} 
        WHERE {&TABLE-NAME}.cod-transp = RowObject.cod-transp NO-ERROR.
    IF AVAIL {&TABLE-NAME} THEN DO:

        ASSIGN v-nome-abrev = {&TABLE-NAME}.nome-abrev.

        ASSIGN {&TABLE-NAME}.nome           = RowObject.nome
               {&TABLE-NAME}.nome-abrev     = RowObject.nome-abrev
               {&TABLE-NAME}.cgc            = RowObject.cgc
               {&TABLE-NAME}.endereco       = RowObject.endereco        
               {&TABLE-NAME}.bairro         = RowObject.bairro        
               {&TABLE-NAME}.estado         = RowObject.estado        
               {&TABLE-NAME}.pais           = RowObject.pais          
               {&TABLE-NAME}.cidade         = RowObject.cidade        
               {&TABLE-NAME}.cep            = RowObject.cep           
               {&TABLE-NAME}.cx-postal      = RowObject.cx-postal
               {&TABLE-NAME}.telefone       = RowObject.telefone
               {&TABLE-NAME}.ramal          = RowObject.ramal         
               {&TABLE-NAME}.telefax        = RowObject.telefax       
               {&TABLE-NAME}.ramal-fax      = RowObject.ramal-fax     
               {&TABLE-NAME}.e-mail         = RowObject.e-mail        
               {&TABLE-NAME}.home-page      = RowObject.home-page   
               {&TABLE-NAME}.ins-estadual   = RowObject.ins-estadual  
               {&TABLE-NAME}.ins-municipal  = RowObject.ins-municipal 
               {&TABLE-NAME}.natureza       = RowObject.natureza
               {&TABLE-NAME}.dat-ult-alter  = TODAY.

        RUN pi-atualiza-tab-integradas.
    END.

end procedure.


procedure executeDelete:
    /*
    **  Executa Delete
    */

    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.02' AND '{&mguni_version}' < '2.07' &THEN
    find first param-global no-lock no-error.
    if avail param-global then do:

        &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
            if param-global.modulo-tf = yes then do:
        &ELSE
            if param-global.int-2 = 1 then do:
        &ENDIF
                if not valid-handle(h-bosc025) then
                    run scbo/bosc025.p persistent set h-bosc025.

                run goToKey in h-bosc025 (input RowObject.nome-abrev).
                run deleteRecord in h-bosc025.

                if return-value <> "OK":U then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Transporte_Fretes" *}
                    run utp/ut-msgs.p (input "msg",
                                       input 3,
                                       input RETURN-VALUE).
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 3
                           tt-bo-erro.mensagem     = return-value.
                    return error.
                end.

                IF VALID-HANDLE(h-bosc025) THEN DO:
                    DELETE PROCEDURE h-bosc025.
                    ASSIGN h-bosc025 = ?.
                END.

            end.
    end. /* avail param-global */
    &ENDIF

    delete {&TABLE-NAME}.
end procedure.


procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.


{adbo/boad268.i1} /** para utilizaá∆o pelo Magnus **/

 
&if defined(bf-mat-comex) &then      
&else
    procedure validateFields:
        /*
        **  Valida Fields
        */
        find first rowObject
            no-lock no-error.
     
        run startMethod ("validateFields").
        if rowObject.bairro = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cep = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cgc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cidade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
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
     
        if rowObject.contato = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.endereco = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
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
     
        if rowObject.ins-estadual = ? then do:
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
     
        if rowObject.nome = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nome-abrev = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.pais = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ramal = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telefax = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telefone = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telex = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.via-transp = ? then do:
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
    
    
    procedure validateUpd:
        /*
        **  Valida criaá∆o da tabela/duplicidade de registro.
        */
        def input  parameter table for RowObject.
        def output parameter table for tt-bo-erro.
        def output parameter r-chave as rowid.
     
        run initializeValidate.
        run startMethod ("validateUpd").
     
        for each tt-bo-erro:
            delete tt-bo-erro.
        end.
     
        find first rowObject
            no-lock no-error.
        if rowObject.bairro = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} bairro 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cep = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cep 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cgc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cgc 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cidade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cidade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cod-emitente = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-emitente 1}
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
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-transp 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.contato = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} contato 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.endereco = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} endereco 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.estado = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} estado 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ins-estadual = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ins-estadual 1}
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
            {utp/ut-field.i mgadm {&TABLE-NAME} natureza 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nome = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nome 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nome-abrev = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nome-abrev 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.pais = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} pais 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ramal = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ramal 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telefax = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telefax 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telefone = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telefone 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telex = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telex 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.via-transp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} via-transp 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        run validateFields.
        find first tt-bo-erro
            no-lock no-error.
     
        if not avail tt-bo-erro then do:
           run executeUpd.
           assign r-chave = to-rowid(return-value).
        end.
     
        run endMethod ("validateUpd").
    end procedure.
    
     
    procedure validateCreate:
        /*
        **  Valida criaá∆o da tabela/duplicidade de registro.
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
        if rowObject.bairro = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} bairro 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cep = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cep 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cgc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cgc 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cidade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cidade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cod-emitente = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-emitente 1}
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
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-transp 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.contato = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} contato 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.endereco = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} endereco 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.estado = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} estado 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ins-estadual = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ins-estadual 1}
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
            {utp/ut-field.i mgadm {&TABLE-NAME} natureza 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nome = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nome 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nome-abrev = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nome-abrev 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.pais = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} pais 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ramal = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ramal 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telefax = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telefax 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telefone = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telefone 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telex = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telex 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.via-transp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} via-transp 1}
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
            find transporte where
                transporte.cod-transp = rowObject.cod-transp
                no-lock no-error.
            if avail transporte then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i mgadm {&TABLE-NAME} 1}
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
     
    procedure validateDelete:
        /*
        **  Valida Delete
        */
        def input-output parameter r-chave as rowid.
        def output parameter table for tt-bo-erro.
     
        run InitializeValidate.
         
        find first rowObject no-lock no-error.   
        
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            exclusive-lock no-error.
        if avail {&TABLE-NAME} then do:
    
           /***** ATENCAO - Uso de Pre-processador *******/
           &if defined (bf_dis_desc_bonif) &then  /* pre-processador */   
               run verificarRelacoesEliminarTransporte.
           &endif /* preprocessador */
           /***** fim - Uso de Pre-processador *******/
       
           find first tt-bo-erro no-lock no-error.
           if not avail tt-bo-erro then
              run executeDelete.
        end.
     
        if l-query then
            get next {&QUERY-NAME}
                no-lock no-wait.
        else
            find next {&TABLE-NAME}
                no-lock no-error.
    
        if not avail {&TABLE-NAME} then do:
           if l-query then
               get prev {&QUERY-NAME}
                   no-lock no-wait.
           else
               find prev {&TABLE-NAME}
                   no-lock no-error.
        end.
        assign r-chave = rowid({&TABLE-NAME}).
        return "".
    end procedure.  
&endif
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "bairro" then c-value = RowObject.bairro.
        when "cgc" then c-value = RowObject.cgc.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "cidade" then c-value = RowObject.cidade.
        when "contato" then c-value = RowObject.contato.
        when "cx-postal" then c-value = RowObject.cx-postal.
        when "endereco" then c-value = RowObject.endereco.
        when "estado" then c-value = RowObject.estado.
        when "ins-estadual" then c-value = RowObject.ins-estadual.
        when "ins-municipal" then c-value = RowObject.ins-municipal.
        when "nome" then c-value = RowObject.nome.
        when "nome-abrev" then c-value = RowObject.nome-abrev.
        when "pais" then c-value = RowObject.pais.
        when "ramal" then c-value = RowObject.ramal.
        when "telefax" then c-value = RowObject.telefax.
        when "telefone" then c-value = RowObject.telefone.
        when "telex" then c-value = RowObject.telex.
        when "zip-code" then c-value = RowObject.zip-code.
        &if  defined(bf_dis_controle_fretes) &then
		when "des-ident-transp" then c-value = rowObject.des-ident-transp.
	 &endif
        &if defined(bf-mat-comex) &then      
            when "natureza" then c-value = RowObject.natureza.
        &else
            when "cep" then c-value = RowObject.cep.                      
            when "check-sum" then c-value = RowObject.check-sum.  
            when "e-mail" then c-value = RowObject.e-mail.        
            when "home-page" then c-value = RowObject.home-page.   
            when "ramal-fax" then c-value = RowObject.ramal-fax.   
            when "ramal-modem" then c-value = RowObject.ramal-modem.
            when "telef-modem" then c-value = RowObject.telef-modem.                                                   
        &endif	 
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "cod-transp" then c-value = RowObject.cod-transp.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "via-transp" then c-value = RowObject.via-transp.
        &if  defined(bf_dis_controle_fretes) &then
		when "cdn-parcei-edi" then c-value = rowObject.cdn-parcei-edi.
    	 &endif
        &if defined(bf-mat-comex) &then      
        &else
            when "natureza" then c-value = RowObject.natureza.
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
        &if  defined(bf_dis_controle_fretes) &then
		when "log-edi" then c-value = rowObject.log-edi.
	 &endif
        &if defined(bf-mat-comex) &then      
        &else
            when "log-2" then c-value = RowObject.log-2.        
        &endif
        otherwise return error.
    end case.
end procedure.


/* Busca do Transportador o Cod Emitente */
PROCEDURE findCodEmitTransp:
    DEF INPUT  PARAM cod-transp     LIKE transporte.cod-transp NO-UNDO.
    DEF OUTPUT PARAM cod-emitente   LIKE emitente.cod-emitente NO-UNDO.

    DEFINE VARIABLE nContEmit   AS INTEGER     NO-UNDO.
    
    FIND FIRST transporte NO-LOCK 
         WHERE transporte.cod-transp = cod-transp NO-ERROR.
    IF AVAILABLE transporte THEN DO:
        FOR EACH emitente NO-LOCK 
           WHERE emitente.cgc = transporte.cgc
             AND emitente.identific <> 1: /* 1=cliente; 2=fornecedor; 3=ambos */
           
           FIND FIRST dist-emitente NO-LOCK /* consulta a situaá∆o do fornecedor */
                WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
           IF AVAIL dist-emitente THEN DO:
              IF dist-emitente.idi-sit-fornec <> 4 THEN /* se estiver como inativo desconsidera na contagem */
                 ASSIGN cod-emitente = emitente.cod-emitente
                        nContEmit = nContEmit + 1.
           END.                           
           ELSE  /* Se n∆o existir a tabela dist-emitente considera como ativo */
              ASSIGN cod-emitente = emitente.cod-emitente
                     nContEmit = nContEmit + 1.
        END.   

        IF nContEmit > 1 THEN DO: /* Se houver mais de um fornecedor localizar com cgc e nome-abrev iguais. */
            ASSIGN cod-emitente = 0.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cgc        = transporte.cgc
                   AND emitente.nome-abrev = transporte.nome-abrev 
                   AND emitente.identific <> 1 NO-ERROR.
            IF AVAILABLE emitente THEN DO:
                ASSIGN cod-emitente = emitente.cod-emitente.

                RETURN "OK":U.
            END.
        END.
        ELSE DO:
            FIND FIRST emitente NO-LOCK /* se localizou somente um ir direto ao que tiver mesmo cgc */
                 WHERE emitente.cod-emitente = cod-emitente NO-ERROR.
            IF AVAILABLE emitente THEN 
                RETURN "OK":U.
            ELSE
                ASSIGN cod-emitente = 0.
        END.

        IF cod-emitente = 0 THEN DO: /* Se ainda n∆o localizou tenta pelo registro com mesmo nome-abrev ou cgc */
            
            FIND FIRST emitente NO-LOCK
                 WHERE emitente.nome-abrev = transporte.nome-abrev NO-ERROR.
            IF AVAILABLE emitente THEN DO:
                ASSIGN cod-emitente = emitente.cod-emitente.
                RETURN "OK":U.
            END.
            ELSE DO:
                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cgc        = transporte.cgc NO-ERROR.
                IF AVAILABLE emitente THEN DO:
                   ASSIGN cod-emitente = emitente.cod-emitente.

                   RETURN "OK":U.
                END.
            END. 
        END.

    END.

    IF NOT AVAIL transporte THEN DO:

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = cod-transp NO-ERROR.
        IF AVAILABLE emitente THEN DO:
            ASSIGN cod-emitente = emitente.cod-emitente.

            RETURN "OK":U.
        END.

    END.

    IF cod-emitente = 0 THEN DO:
        ASSIGN cod-emitente = cod-transp.

        RETURN "OK":U.
    END.

    RETURN "NOK":U.

END PROCEDURE.

/***** ATENCAO - Uso de Pre-processador *******/
&if defined (bf_dis_desc_bonif) &then  /* pre-processador */   

    procedure verificarRelacoesEliminarTransporte:
    /*
    MÇtodo implementado para realizar a validaá∆o na  eliminaá∆o da tabela transporte e verificar se 
    a transporte est† sendo usado nas tabelas canal cliente. 
    */
        def var c-texto       as char extent 2 no-undo.

    
        find first param-global
            no-lock no-error.
    
        if param-global.modulo-09 then do: /* modulo BN */ 

            if can-find (first canal-cliente where 
                               canal-cliente.cod-transp = transporte.cod-transp) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis canal-cliente 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,        /* Transporte possui relacionamentos ativos com Canal Cliente. */
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.          
               assign tt-bo-erro.parametros    = c-texto[1] + "~~" + c-texto[2].
                      
            end.

        end. /* param-global */    
    end procedure.
    
&endif /* preprocessador */
/***** fim - Uso de Pre-processador *******/
/**/

procedure pi-atualiza-tab-integradas:
    define variable h-api as handle      no-undo.
    
    /*Atualizaá∆o do nome-abrev*/
    if  v-nome-abrev <> RowObject.nome-abrev then do:

        for each b-estab where b-estab.nome-transp = v-nome-abrev no-lock:
            for first estab-cli where rowid(estab-cli) = rowid(b-estab) exclusive-lock :
                assign estab-cli.nome-transp = RowObject.nome-abrev.
            end.
        end.

        for each  b-nota
            where b-nota.nome-transp = v-nome-abrev
            or    b-nota.nome-tr-red = v-nome-abrev no-lock:
            for first nota-fiscal where rowid(nota-fiscal) = rowid(b-nota) exclusive-lock:
                if  b-nota.nome-transp = v-nome-abrev then
                    assign nota-fiscal.nome-transp = RowObject.nome-abrev.
                if  b-nota.nome-tr-red = v-nome-abrev then
                    assign nota-fiscal.nome-tr-red = RowObject.nome-abrev.
            end.
        end.

        for each  b-ped
            where b-ped.nome-transp = v-nome-abrev
            or    b-ped.nome-tr-red = v-nome-abrev no-lock:
            for first ped-venda where rowid(ped-venda) = rowid(b-ped) exclusive-lock :
                if  b-ped.nome-transp = v-nome-abrev then
                    assign ped-venda.nome-transp = RowObject.nome-abrev.
                if  b-ped.nome-tr-red = v-nome-abrev then
                    assign ped-venda.nome-tr-red = RowObject.nome-abrev.
            end.
        end.

        for each  b-emitente
            where b-emitente.nome-tr-red = v-nome-abrev no-lock:
            for first emitente where rowid(emitente) = rowid(b-emitente) exclusive-lock:
                assign emitente.nome-tr-red = RowObject.nome-abrev.
            end.
        end.

        for each  b-imag-for
            where b-imag-for.nome-tr-red = v-nome-abrev no-lock:
            for first imag-for where rowid(imag-for) = rowid(b-imag-for) exclusive-lock:
                assign imag-for.nome-tr-red = RowObject.nome-abrev.
            end.
        end.

        for each  b-ender-red
            where b-ender-red.nome-tr-red = v-nome-abrev no-lock:
            for first ender-red where rowid(ender-red) = rowid(b-ender-red) exclusive-lock:
                assign ender-red.nome-tr-red = RowObject.nome-abrev.
            end.
        end.

        for each  b-embarque
            where b-embarque.nome-transp = v-nome-abrev no-lock:
            for first embarque where rowid(embarque) = rowid(b-embarque) exclusive-lock:
                assign embarque.nome-transp = RowObject.nome-abrev.
            end.
        end.

        for each  b-pre-fatur
            where b-pre-fatur.nome-transp = v-nome-abrev
            or    b-pre-fatur.nome-tr-red = v-nome-abrev no-lock:
            for first pre-fatur where rowid(pre-fatur) = rowid(b-pre-fatur) exclusive-lock:
                if  b-pre-fatur.nome-transp = v-nome-abrev then
                    assign pre-fatur.nome-transp = RowObject.nome-abrev.
                if  b-pre-fatur.nome-tr-red = v-nome-abrev then
                    assign pre-fatur.nome-tr-red = RowObject.nome-abrev.
            end.
        end.

        for each  b-remito
            where b-remito.nome-transp = v-nome-abrev no-lock:
            for first remito where rowid(remito) = rowid(b-remito) exclusive-lock:
                if b-remito.nome-transp = v-nome-abrev then
                    assign remito.nome-transp = RowObject.nome-abrev.
            end.
        end.

        for each  b-doc-fiscal
            where b-doc-fiscal.nome-transp = v-nome-abrev no-lock:
            for first doc-fiscal where rowid(doc-fiscal) = rowid(b-doc-fiscal) exclusive-lock:
                if b-doc-fiscal.nome-transp = v-nome-abrev then 
                    assign doc-fiscal.nome-transp = RowObject.nome-abrev.
            end.
        end.

        for each  b-loc-entr
            where b-loc-entr.nome-transp = v-nome-abrev no-lock:
             for first loc-entr where rowid(loc-entr) = rowid(b-loc-entr) exclusive-lock:
                 if b-loc-entr.nome-transp = v-nome-abrev then
                     assign loc-entr.nome-transp = RowObject.nome-abrev.
             end.
         end.

        /* SFA */
        if CONNECTED("mgscm") THEN do:
            run sfc/sfapi014.p persistent set h-api.
            run atualizaTranspSFA in h-api (INPUT RowObject.cod-transp,
                                            input v-nome-abrev).
            delete procedure h-api.
            assign h-api = ?.
        end.

        for each  b-simul-emb
            where b-simul-emb.nome-transp = v-nome-abrev no-lock:
            for first simul-emb where rowid(simul-emb) = rowid(b-simul-emb) exclusive-lock:
                if b-simul-emb.nome-transp = v-nome-abrev then
                    assign simul-emb.nome-transp = RowObject.nome-abrev.
            end.
        end.
    end. /*Fim v-nome-abrev*/
end procedure.
