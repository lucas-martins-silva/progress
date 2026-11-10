/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN672 2.00.00.005 } /*** 010005 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin672 MUT}
&ENDIF

/*************************************************************************************
**
**       Programa.: BOIN672   
**
**       Objetivo.: Gera‡Æo de Movimentos de Devolu‡Æo a Fornecedor
**
**************************************************************************************/   
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY devol-forn
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME devol-forn
 
  
{include/boini.i}
 
{inbo/boin672.i RowObject}
 
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/boexecre.i}

{include/boexedel.i}

{include/bovalupt.i}

{include/i-epc200.i "boin672"}


DEFINE VARIABLE l-tem-epc                    AS LOGICAL  INIT NO  NO-UNDO.
DEFINE VARIABLE l-nao-encontrou-item-doc-est AS LOGICAL  INIT NO  NO-UNDO.
 
procedure geraBoErro:
    def input param i-sequencia as integer no-undo.
    def input param i-cod-erro  as integer no-undo.
    def input param c-complem   as char    no-undo.

    run utp/ut-msgs.p (input "msg",
                       input i-cod-erro,
                       input c-complem).

    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-sequencia
           tt-bo-erro.cd-erro      = i-cod-erro
           tt-bo-erro.mensagem     = return-value.
end procedure. 
 
procedure validateCreate:
    /*
    **  Valida cria»’o da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.

    def var i-sequencia as integer no-undo.
     
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    assign i-sequencia = 0.
    
    for each RowObject exclusive-lock:

        /*    run initializeValidate. */
        run startMethod ("validateCreate").
     
        assign i-sequencia = i-sequencia + 1
               RowObject.i-sequen = i-sequencia.

        run validateFields.
    
        find first tt-bo-erro 
            where tt-bo-erro.i-sequen = RowObject.i-sequen no-lock no-error.
    
        if  not available tt-bo-erro then do:
            find devol-forn 
                where devol-forn.serie-docto    = RowObject.serie-docto
                  and devol-forn.nro-docto      = RowObject.nro-docto
                  and devol-forn.cod-emitente   = RowObject.cod-emitente
                  and devol-forn.nat-operacao   = RowObject.nat-operacao
                  and devol-forn.sequencia      = RowObject.sequencia
                  and devol-forn.cod-estabel    = RowObject.cod-estabel
                  and devol-forn.serie          = RowObject.serie
                  and devol-forn.nr-nota-fis    = RowObject.nr-nota-fis
                  and devol-forn.nr-seq-fat     = RowObject.nr-seq-fat
                  and devol-forn.it-codigo      = RowObject.it-codigo
                no-lock no-error.
            if  avail devol-forn then do:
                {utp/ut-table.i movind {&TABLE-NAME} 1}
                run utp/ut-msgs.p (input "msg",
                                   input 8,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = RowObject.i-sequen
                       tt-bo-erro.cd-erro      = 8
                       tt-bo-erro.mensagem     = return-value.
            end.
            else do:
                run executeCreate.
                assign r-chave = to-rowid(return-value).
            end.
        end.
     
        run endMethod ("validateCreate").
    end.        
end procedure.

  
procedure validateFields:
    /*
    **  Valida Fields
    */
    def var de-saldo-devol as decimal no-undo.
 
    run startMethod ("validateFields").
    
    if  RowObject.cod-estabel = ? then do:
        {utp/ut-field.i movind {&TABLE-NAME} cod-estabel 1}
        run geraBoErro ( input RowObject.i-sequen,
                         input 265,
                         input return-value ).
    end.
 
    if  RowObject.it-codigo = ? then do:
        {utp/ut-field.i movind {&TABLE-NAME} it-codigo 1}
        run geraBoErro ( input RowObject.i-sequen,
                         input 265,
                         input return-value ).
    end.
 
    if  RowObject.nr-nota-fis = ? then do:
        {utp/ut-field.i movind {&TABLE-NAME} nr-nota-fis 1}
        run geraBoErro ( input RowObject.i-sequen,
                         input 265,
                         input return-value ).
    end.
 
    if  RowObject.nr-seq-fat = ? then do:
        {utp/ut-field.i movind {&TABLE-NAME} nr-seq-fat 1}
        run geraBoErro ( input RowObject.i-sequen,
                         input 265,
                         input return-value ).
    end.
 
    if  RowObject.serie = ? then do:
        {utp/ut-field.i movind {&TABLE-NAME} serie 1}
        run geraBoErro ( input RowObject.i-sequen,
                         input 265,
                         input return-value ).
    end.
 
    if  RowObject.vl-devol = ? then do:
        {utp/ut-field.i movind {&TABLE-NAME} vl-devol 1}
        run geraBoErro ( input RowObject.i-sequen,
                         input 265,
                         input return-value ).
    end.

 
    find item-doc-est
        where item-doc-est.cod-emitente = RowObject.cod-emitente
          and item-doc-est.serie-docto  = RowObject.serie-docto
          and item-doc-est.nat-operacao = RowObject.nat-operacao
          and item-doc-est.nro-docto    = RowObject.nro-docto
          and item-doc-est.sequencia    = RowObject.sequencia
        no-lock no-error.

    IF NOT AVAIL item-doc-est THEN DO:
        
        run geraBoErro ( input RowObject.i-sequen,
                         input 2,
                         input "Itens NF Movimentadas p/ Estoq" ).

        IF c-nom-prog-upc-mg97  <> "" THEN DO:

            /**************************** FO1215.994 - Grendene *****************************************/
            FOR EACH tt-epc
                WHERE tt-epc.cod-event     = "buscaItemBcoHist":U:
                DELETE tt-epc.
            END.
    
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "buscaItemBcoHist":U
                   tt-epc.cod-parameter = "chave-item-doc-est":U
                   tt-epc.val-parameter = (string(RowObject.cod-emitente) + "," + 
                                           string(RowObject.serie-docto)  + "," + 
                                           string(RowObject.nat-operacao) + "," +  
                                           string(RowObject.nro-docto)    + "," + 
                                           string(RowObject.sequencia)).
       
            {include/i-epc201.i "buscaItemBcoHist"}
          
            FIND FIRST tt-epc 
                WHERE tt-epc.cod-event     = "buscaItemBcoHist":U 
                  AND tt-epc.cod-parameter = "l-nao-encontrou-item-doc-est" NO-LOCK NO-ERROR.
       
            IF AVAIL tt-epc THEN 
                ASSIGN l-nao-encontrou-item-doc-est = IF tt-epc.val-parameter = "SIM" THEN YES ELSE NO
                       l-tem-epc = YES.

            IF l-tem-epc AND l-nao-encontrou-item-doc-est = YES THEN DO:

                FIND tt-bo-erro
                    WHERE tt-bo-erro.i-sequen = rowObject.i-sequen 
                      AND tt-bo-erro.cd-erro  = 2
                      AND tt-bo-erro.mensagem = "Itens NF Movimentadas p/ Estoq" NO-LOCK NO-ERROR.
                IF AVAIL tt-bo-erro THEN
                    DELETE tt-bo-erro.

                run calculaSaldoDevolver  ( input RowObject.serie-docto,
                                            input RowObject.nro-docto,
                                            input RowObject.cod-emitente,
                                            input RowObject.nat-operacao,
                                            input RowObject.sequencia,
                                            output de-saldo-devol ).
                                            
                if  de-saldo-devol < RowObject.qt-devol then do:
                    run geraBoErro ( input RowObject.i-sequen,
                                     input 17773,
                                     input " " ).
                end.                             
            end.
        END. /*fim upc */
    END.
    ELSE DO:

        run calculaSaldoDevolver  ( input RowObject.serie-docto,
                                    input RowObject.nro-docto,
                                    input RowObject.cod-emitente,
                                    input RowObject.nat-operacao,
                                    input RowObject.sequencia,
                                    output de-saldo-devol ).
                                    
        if  de-saldo-devol < RowObject.qt-devol then do:
            run geraBoErro ( input RowObject.i-sequen,
                             input 17773,
                             input " " ).
        end.
    END.
     
    run endMethod ("validateFields").
 
end procedure.
 

procedure calculaSaldoDevolver:

    /** Calcular o Saldo que pode ser Devolvido */
    
    def input param c-serie-docto   like devol-forn.serie-docto  no-undo.
    def input param c-nro-docto     like devol-forn.nro-docto    no-undo.
    def input param i-cod-emitente  like devol-forn.cod-emitente no-undo.
    def input param c-nat-operacao  like devol-forn.nat-operacao no-undo.
    def input param i-sequencia     like devol-forn.sequencia    no-undo.
    def output param de-qtd-saldo   like item-doc-est.quantidade no-undo.
    
    def var de-qtd-devol            as decimal no-undo.
    
    find item-doc-est
        where item-doc-est.serie-docto  = c-serie-docto 
          and item-doc-est.nro-docto    = c-nro-docto
          and item-doc-est.cod-emitente = i-cod-emitente
          and item-doc-est.nat-operacao = c-nat-operacao
          and item-doc-est.sequencia    = i-sequencia no-lock no-error.
          
    assign de-qtd-saldo = if  avail item-doc-est then 
                              item-doc-est.quantidade 
                          else 
                              0.
    
    IF  c-nom-prog-upc-mg97  <> "" THEN DO:

        /**************************** FO1215.994 - Grendene *****************************************/
        IF NOT AVAIL item-doc-est THEN DO:
            FOR EACH tt-epc
                WHERE tt-epc.cod-event     = "buscaSaldoDevolverBcoHist":U:
                DELETE tt-epc.
            END.
    
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "buscaSaldoDevolverBcoHist":U
                   tt-epc.cod-parameter = "chave-item-doc-est":U
                   tt-epc.val-parameter = (string(i-cod-emitente) + "," + 
                                           string(c-serie-docto)  + "," + 
                                           string(c-nat-operacao) + "," +  
                                           string(c-nro-docto)    + "," + 
                                           string(i-sequencia)).
        
            {include/i-epc201.i "buscaSaldoDevolverBcoHist"}
         
            FIND FIRST tt-epc 
                WHERE tt-epc.cod-event     = "buscaSaldoDevolverBcoHist":U 
                  AND tt-epc.cod-parameter = "quantidade-item-doc-est" NO-LOCK NO-ERROR.
        
            IF AVAIL tt-epc THEN 
                ASSIGN de-qtd-saldo = dec(tt-epc.val-parameter).

        END.

    END.
    run calculaQuantDevolvida ( input c-serie-docto,
                                input c-nro-docto,
                                input i-cod-emitente,
                                input c-nat-operacao,
                                input i-sequencia,
                                output de-qtd-devol ).
    
    assign de-qtd-saldo = de-qtd-saldo - de-qtd-devol.

end procedure.


procedure calculaQuantDevolvida:

    def input param c-serie-docto   like devol-forn.serie-docto  no-undo.
    def input param c-nro-docto     like devol-forn.nro-docto    no-undo.
    def input param i-cod-emitente  like devol-forn.cod-emitente no-undo.
    def input param c-nat-operacao  like devol-forn.nat-operacao no-undo.
    def input param i-sequencia     like devol-forn.sequencia    no-undo.
    def output param de-qtd-devol as decimal no-undo.

    assign de-qtd-devol = 0.
    
    for each devol-forn
       where devol-forn.serie-docto  = c-serie-docto 
         and devol-forn.nro-docto    = c-nro-docto
         and devol-forn.cod-emitente = i-cod-emitente
         and devol-forn.nat-operacao = c-nat-operacao 
         and devol-forn.sequencia    = i-sequencia no-lock:

        assign de-qtd-devol = de-qtd-devol + devol-forn.qt-devol.
    end.        

end procedure.


procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input  parameter table for RowObject.

    /*  run InitializeValidate. */
 
    for each RowObject no-lock :

        find {&TABLE-NAME} 
            where {&TABLE-NAME}.serie-docto    = RowObject.serie-docto
              and {&TABLE-NAME}.nro-docto      = RowObject.nro-docto
              and {&TABLE-NAME}.cod-emitente   = RowObject.cod-emitente
              and {&TABLE-NAME}.nat-operacao   = RowObject.nat-operacao
              and {&TABLE-NAME}.sequencia      = RowObject.sequencia
              and {&TABLE-NAME}.cod-estabel    = RowObject.cod-estabel
              and {&TABLE-NAME}.serie          = RowObject.serie
              and {&TABLE-NAME}.nr-nota-fis    = RowObject.nr-nota-fis
              and {&TABLE-NAME}.nr-seq-fat     = RowObject.nr-seq-fat
              and {&table-name}.it-codigo      = RowObject.it-codigo
            exclusive-lock no-error.
            
        if  avail {&TABLE-NAME} then do:
            run executeDelete.
        end.
    end.
    
    return "".
end procedure.


 
