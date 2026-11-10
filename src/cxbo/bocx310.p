/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX310 2.00.00.058 } /*** "010058" 01/10/2025 16:10:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx310 MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX310.P
**
**  desp-embarque - Despesas do Embarque
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY desp-embarque
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME desp-embarque

{include/boini.i}
{cxbo/bocx310.i RowObject}
{cxbo/bocx310.i tt-desp-embarque}
{cxbo/bocx310.i tt-desp-embarque-old}
{cxbo/bocx310.i tt-desp-embarque-aux} 
{method/dbotterr.i}           /* definicao RowErrors */
{include/i-epc200.i BOCX310}  /* definicao referente a UPC */

{utp/ut-glob.i}

{cdp/cdcfgmat.i} /* Include com pre-processadores */
{cdp/cdcfgdis.i} /* Include com pre-processadores */

{cdp/cd4300.i3}  /* Atributos livres */
{imp/im0091.i}   /* Definicao de temp-tables */
{imp/im7777.i1}  /* Definicao de temp-tables */

DEFINE BUFFER bf-desp-embarque FOR desp-embarque.

DEFINE QUERY {&QUERY-NAME} for desp-embarque scrolling.

def var c-estabel    like desp-embarque.cod-estabel    no-undo.
def var c-embarque   like desp-embarque.embarque       no-undo.
def var i-itiner     like desp-embarque.cod-itiner     no-undo.
def var i-pto-contr  like desp-embarque.cod-pto-contr  no-undo.
def var i-cod-despesa   as integer no-undo.
def var i-cod-emit-desp as integer no-undo.
def var hDBOitinerario as handle no-undo.
def var hDBOhist-embarque as handle no-undo.
def var i-msg          as int     no-undo.
def var c-msg          as char    no-undo.
def var c-char         as char    no-undo.
DEF VAR h-cdapi050     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx407 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx230 AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-pto-contr-ini LIKE historico-embarque.cod-pto-contr     NO-UNDO.
DEFINE VARIABLE i-pto-contr-fim LIKE historico-embarque.cod-pto-contr     NO-UNDO.
DEFINE VARIABLE i-cod-desp-ini  LIKE desp-embarque.cod-desp               NO-UNDO.
DEFINE VARIABLE i-cod-desp-fim  LIKE desp-embarque.cod-desp               NO-UNDO.
DEFINE VARIABLE i-mo-codigo     LIKE desp-embarque.mo-codigo              NO-UNDO.


DEFINE VARIABLE l-possui-di             AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE i-seq-nacionaliz        AS INTEGER                           NO-UNDO.
DEFINE VARIABLE i-cod-itiner            AS INTEGER                           NO-UNDO.
DEFINE VARIABLE i-seq-pto               AS INTEGER                           NO-UNDO.
DEFINE VARIABLE i-seq-novo-ponto        AS INTEGER                           NO-UNDO.
DEFINE VARIABLE i-cdn-pto-nacionaliz    LIKE embarque-imp.cdn-pto-desembar   NO-UNDO. 
DEFINE VARIABLE i-cdn-pto-chegada       LIKE embarque-imp.cdn-pto-chegad     NO-UNDO. 
DEFINE VARIABLE l-update-rateio-im3101d AS LOGICAL   INITIAL NO              NO-UNDO.
DEFINE VARIABLE l-nt2024002             AS LOGICAL                           NO-UNDO.

DEFINE TEMP-TABLE tt-desp-rateio-old NO-UNDO LIKE tt-desp-rateio.

DEFINE TEMP-TABLE tt-desp-rateio-aux NO-UNDO LIKE tt-desp-rateio.

DEFINE TEMP-TABLE tt-campo-erro NO-UNDO
    FIELD campo       AS CHARACTER.
    
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).

procedure setConstraint1:
end procedure.

procedure setConstraint2:
    def input parameter p-estabel    like desp-embarque.cod-estabel    no-undo.
    def input parameter p-embarque   like desp-embarque.embarque       no-undo.
    def input parameter p-itiner     like desp-embarque.cod-itiner     no-undo.
    def input parameter p-pto-contr  like desp-embarque.cod-pto-contr  no-undo.
    
    assign c-estabel   = p-estabel
           c-embarque  = p-embarque
           i-itiner    = p-itiner
           i-pto-contr = p-pto-contr.
 
end procedure.

procedure setConstraint3:
    def input parameter p-estabel    like desp-embarque.cod-estabel    no-undo.
    def input parameter p-embarque   like desp-embarque.embarque       no-undo.
    
    assign c-estabel  = p-estabel
           c-embarque = p-embarque.
    
end procedure.

procedure setConstraint4:
/*
** procedure utilizada no browser de despesas por 
** pontos do embarque de importaá∆o - thinTemplates 
*/
def input parameter p-rowid as rowid no-undo.

find historico-embarque where 
     rowid(historico-embarque) = p-rowid no-lock no-error.

end procedure.

procedure setConstraint5:
    define input parameter p-cod-estab        as char     no-undo.
    define input parameter p-cod-embarq       as char     no-undo.
    define input parameter p-cdn-despes       as integer  no-undo.
    define input parameter p-cdn-emit-despes  as integer  no-undo.
    define input parameter p-cdn-pto-control  as integer  no-undo.

    assign c-estabel       = p-cod-estab
           c-embarque      = p-cod-embarq
           i-cod-despesa   = p-cdn-despes
           i-cod-emit-desp = p-cdn-emit-despes
           i-pto-contr     = p-cdn-pto-control.


end procedure.

procedure setConstraint6:
/*
** procedure utilizada no browser de despesas por pontos do embarque de importaá∆o (im0055)
*/
    def input parameter p-rowid   as rowid no-undo.
    def input parameter p-pto-ini as int   no-undo.
    def input parameter p-pto-fim as int   no-undo.

    FIND FIRST historico-embarque 
         WHERE ROWID(historico-embarque) = p-rowid NO-LOCK NO-ERROR.

    ASSIGN i-pto-contr-ini = p-pto-ini
           i-pto-contr-fim = p-pto-fim.
END PROCEDURE.

procedure setConstraint7:
/*
** Filtro por ponto de controle / c¢digo despesa / moeda
*/
    def input parameter p-estabel  like desp-embarque.cod-estabel   no-undo.
    def input parameter p-embarque like desp-embarque.embarque      no-undo.
    def input parameter p-pto-ini  like desp-embarque.cod-pto-contr no-undo.
    def input parameter p-pto-fim  like desp-embarque.cod-pto-contr no-undo.
    def input parameter p-desp-ini like desp-embarque.cod-desp      no-undo.
    def input parameter p-desp-fim like desp-embarque.cod-desp      no-undo.
    def input parameter p-moeda    like desp-embarque.mo-codigo     no-undo.

    FIND FIRST historico-embarque
         WHERE historico-embarque.cod-estabel = p-estabel
           AND historico-embarque.embarque = p-embarque NO-LOCK NO-ERROR.

    ASSIGN i-pto-contr-ini = p-pto-ini
           i-pto-contr-fim = p-pto-fim
           i-cod-desp-ini  = p-desp-ini
           i-cod-desp-fim  = p-desp-fim
           i-mo-codigo     = p-moeda.
END PROCEDURE.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.

    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each desp-embarque no-lock.    
        when 2 then
            open query {&QUERY-NAME} for each desp-embarque where 
                                              desp-embarque.cod-estabel   = c-estabel  and                                              
                                              desp-embarque.embarque      = c-embarque and
                                              desp-embarque.cod-itiner    = i-itiner   and
                                              desp-embarque.cod-pto-contr = i-pto-contr 
                                              no-lock.
        when 3 then
            open query {&QUERY-NAME} for each desp-embarque where 
                                              desp-embarque.cod-estabel = c-estabel and
                                              desp-embarque.embarque    = c-embarque
                                              no-lock.                                                  
        when 4 then 
            open query {&QUERY-NAME} for each desp-embarque no-lock where
                desp-embarque.cod-estabel   = historico-embarque.cod-estabel and
                desp-embarque.embarque      = historico-embarque.embarque and
                desp-embarque.cod-itiner    = historico-embarque.cod-itiner and
                desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr.                                              
        when 5 then
            open query {&QUERY-NAME} for each desp-embarque 
                                        where desp-embarque.cod-estabel       = c-estabel
                                          and desp-embarque.embarque          = c-embarque
                                          and desp-embarque.cod-desp          = i-cod-despesa
                                          and desp-embarque.cod-emitente-desp = i-cod-emit-desp
                                          and desp-embarque.cod-pto-contr     = i-pto-contr no-lock.
        when 6 then 
            OPEN QUERY {&QUERY-NAME} 
            FOR EACH desp-embarque NO-LOCK 
               WHERE desp-embarque.cod-estabel   = historico-embarque.cod-estabel 
                 AND desp-embarque.embarque      = historico-embarque.embarque 
                 AND desp-embarque.cod-itiner    = historico-embarque.cod-itiner 
                 AND desp-embarque.cod-pto-contr >= i-pto-contr-ini
                 AND desp-embarque.cod-pto-contr <= i-pto-contr-fim.  
        when 7 then 
            OPEN QUERY {&QUERY-NAME} 
            FOR EACH desp-embarque NO-LOCK 
               WHERE desp-embarque.cod-estabel   = historico-embarque.cod-estabel 
                 AND desp-embarque.embarque      = historico-embarque.embarque 
                 AND desp-embarque.cod-itiner    = historico-embarque.cod-itiner 
                 AND desp-embarque.cod-pto-contr >= i-pto-contr-ini
                 AND desp-embarque.cod-pto-contr <= i-pto-contr-fim
                 AND desp-embarque.cod-desp      >= i-cod-desp-ini
                 AND desp-embarque.cod-desp      <= i-cod-desp-fim
                 AND ((i-mo-codigo <> 0 AND desp-embarque.mo-codigo = i-mo-codigo) OR
                      i-mo-codigo = 0)
                 AND NOT desp-embarque.log-despes-ja-recbda.
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
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i} 
/* {include/boexeupt.i} */
{include/boexedel.i} 
/* {include/bovalupt.i} */
/* {include/bovaldel.i} */

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure. 

PROCEDURE findCodigo:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    DEFINE INPUT  PARAMETER pcod-estabel   LIKE desp-embarque.cod-estabel      NO-UNDO.
    DEFINE INPUT  PARAMETER pembarque      LIKE desp-embarque.embarque         NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-itiner    LIKE desp-embarque.cod-itiner       NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-pto-contr LIKE desp-embarque.cod-pto-contr    NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-desp      LIKE desp-embarque.cod-desp         NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return       AS CHARACTER                        NO-UNDO.

    run startMethod("find":U).

    FOR FIRST {&TABLE-NAME} 
        WHERE {&TABLE-NAME}.cod-estabel   = pcod-estabel   
          AND {&TABLE-NAME}.embarque      = pembarque     
          AND {&TABLE-NAME}.cod-itiner    = pcod-itiner   
          AND {&TABLE-NAME}.cod-pto-contr = pcod-pto-contr
          AND {&TABLE-NAME}.cod-desp      = pcod-desp NO-LOCK: END.

    IF NOT AVAIL {&TABLE-NAME} THEN DO:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        RUN utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        ASSIGN c-return = return-value.                           
    END.
    ELSE DO:
        RUN setCurrent.
    END.
    RUN endMethod("find":U).
END PROCEDURE.

PROCEDURE findDespesa:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    DEFINE INPUT  PARAMETER pcod-estabel   LIKE desp-embarque.cod-estabel      NO-UNDO.
    DEFINE INPUT  PARAMETER pembarque      LIKE desp-embarque.embarque         NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-desp      LIKE desp-embarque.cod-desp         NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return       AS CHARACTER                        NO-UNDO.

    run startMethod("find":U).

    FOR FIRST {&TABLE-NAME} 
        WHERE {&TABLE-NAME}.cod-estabel   = pcod-estabel   
          AND {&TABLE-NAME}.embarque      = pembarque     
          AND {&TABLE-NAME}.cod-desp      = pcod-desp NO-LOCK: END.

    IF NOT AVAIL {&TABLE-NAME} THEN DO:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        RUN utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        ASSIGN c-return = return-value.                           
    END.
    ELSE DO:
        RUN setCurrent.
    END.
    RUN endMethod("find":U).
END PROCEDURE.

procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid cod-estabel embarque cod-itiner cod-emitente-desp to desp-embarque.
    RUN pi-grava-siscoserv. /*** Siscoserv ***/

end procedure.

procedure validateFields:
    /*
    **  Valida Fields
    */

    EMPTY TEMP-TABLE tt-campo-erro.

    DEF VAR i-seq-nacionalizacao AS INTEGER NO-UNDO.
    DEF VAR i-seq-despesa        AS INTEGER NO-UNDO.
    DEF VAR c-mensagem           AS CHAR FORMAT "x(70)" NO-UNDO.
    DEF VAR i-cod-erro           AS INTEGER NO-UNDO.
    DEF VAR c-des-erro           AS CHAR NO-UNDO.

    run startMethod("validateFields":U).
    
    find first rowObject  no-lock no-error.

    /* Verifica se o ponto de controle da despesa pertence ao acompanhamento */
    IF NOT CAN-FIND(FIRST historico-embarque 
                    WHERE historico-embarque.cod-estabel   = RowObject.cod-estabel
                      AND historico-embarque.embarque      = RowObject.embarque
                      AND historico-embarque.cod-itiner    = RowObject.cod-itiner
                      AND historico-embarque.cod-pto-contr = RowObject.cod-pto-contr) THEN DO: 
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece pre-processador em chamada de includes */
        {utp/ut-field.i mgcex historico-embarque cod-pto-contr 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg":u,
                           input 54738,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 54738
               tt-bo-erro.mensagem     = return-value.
        create tt-campo-erro.
        assign tt-campo-erro.campo = "cod-pto-contr":U.
    END.

    if not can-find(desp-imp where desp-imp.cod-desp = rowObject.cod-desp) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex desp-embarque cod-desp 1}
        run utp/ut-msgs.p (input "msg",
                           input 47,
                           input return-value + " " + string(rowObject.cod-desp)).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 47
               tt-bo-erro.mensagem = return-value.
        {utp/ut-field.i mgcex desp-embarque cod-desp 1}
        run utp/ut-msgs.p (input "HELP":U,
                           input 47,
                           input return-value + " " + string(rowObject.cod-desp)).
        assign tt-bo-erro.errorhelp = return-value.
        create tt-campo-erro.
        assign tt-campo-erro.campo = "cod-desp":U.
    end. 

    if CAN-FIND(FIRST desp-embarque WHERE desp-embarque.cod-desp = rowObject.cod-desp) AND (rowObject.descricao = ? or trim(rowObject.descricao) = "":U) then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex historico-embarque descricao 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg":u,
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
        create tt-campo-erro.
        assign tt-campo-erro.campo = "descricao":U.
    end.
    
    if not can-find(moeda where moeda.mo-codigo = rowObject.mo-codigo) then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 151,
                           input rowObject.mo-codigo).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 151
               tt-bo-erro.mensagem = return-value.
        create tt-campo-erro.
        assign tt-campo-erro.campo = "mo-codigo":U.
    end.           

    if not can-find(cond-pagto where cond-pagto.cod-cond-pag = rowObject.cod-cond-pag) then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 8303,
                           input rowObject.cod-cond-pag).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 8303
               tt-bo-erro.mensagem = return-value.
        create tt-campo-erro.
        assign tt-campo-erro.campo = "cod-cond-pag":U.
    end.           
    
    if rowObject.val-desp = 0 then do:
        {utp/ut-field.i mgcex desp-embarque val-desp 1}
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 265
               tt-bo-erro.mensagem = return-value.    
        create tt-campo-erro.
        assign tt-campo-erro.campo = "val-desp":U.
    end.
    
    /*frank - 09/05/05*/
    &if defined(bf-mat-comex) &then
    
        /* Verifica se o Incoterm de rateio esta disponivel no Cad. de Incoterms */
        if  substr(rowObject.char-1,1,3) <> "" then do:

            for first inco-cx fields (cod-incoterm)
                where inco-cx.cod-incoterm = substr(rowObject.char-1,1,3) no-lock: end.
            if  avail inco-cx then do:

                for first desp-incoterm fields (cod-desp)
                    where desp-incoterm.cod-incoterm = inco-cx.cod-incoterm
                    and   desp-incoterm.cod-desp     = rowObject.cod-desp no-lock: end.
                if  avail desp-incoterm then do:

                    /* A incoterm de rateio informada nao deve conter em sua 
                       parametrizacao a propria despesa a ser rateada        */
                    assign i-seq-erro = i-seq-erro + 1.
                    run utp/ut-msgs.p (input "msg",
                                       input 30164,
                                       input inco-cx.cod-incoterm + "~~" +
                                             string(rowObject.cod-desp)).
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 30164
                           tt-bo-erro.mensagem = return-value.

                    run utp/ut-msgs.p (input "help":U,
                                       input 30164,
                                       input substr(rowObject.char-1,1,3) + "~~" + 
                                             string(rowObject.cod-desp)).
                                       
                    assign tt-bo-erro.errorhelp  = return-value
                           tt-bo-erro.parametros = substr(rowObject.char-1,1,3) + "~~" + 
                                                   string(rowObject.cod-desp).
                end.
            end.
            else do:

                /* Nao encontrado incoterm para a chave informada */
                assign i-seq-erro = i-seq-erro + 1.

                {utp/ut-liter.i Incoterm}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.

                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input tt-bo-erro.parametros).
                
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 2
                       tt-bo-erro.mensagem = return-value.
            end.
        end.

        /* 
        ** Validacao Moeda do Fornecedor
        */
        FIND FIRST historico-embarque
            WHERE historico-embarque.cod-estabel = rowObject.cod-estabel
              AND historico-embarque.embarque    = rowObject.embarque NO-LOCK NO-ERROR.
        FIND itinerario
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.
        
        FOR FIRST embarque-imp FIELDS(cdn-pto-desembar) 
            WHERE embarque-imp.cod-estab = rowObject.cod-estabel
              AND embarque-imp.embarque =  rowObject.embarque NO-LOCK: END.

        FIND FIRST historico-embarque
             WHERE historico-embarque.cod-estabel   = rowObject.cod-estabel
               AND historico-embarque.embarque      = rowObject.embarque
               AND historico-embarque.cod-itiner    = itinerario.cod-itiner
               AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK NO-ERROR.
        ASSIGN i-seq-nacionalizacao = historico-embarque.sequencia.
    
        FIND historico-embarque
            WHERE historico-embarque.cod-estabel   = rowObject.cod-estabel
              AND historico-embarque.embarque      = rowObject.embarque
              AND historico-embarque.cod-itiner    = itinerario.cod-itiner
              AND historico-embarque.cod-pto-contr = rowObject.cod-pto-contr NO-LOCK NO-ERROR.
        ASSIGN i-seq-despesa = historico-embarque.sequencia.
    
        FOR EACH desp-embarque
            WHERE desp-embarque.cod-estabel       =  rowObject.cod-estabel
              AND desp-embarque.embarque          =  rowObject.embarque
              AND desp-embarque.cod-emitente-desp =  rowObject.cod-emitente-desp
              AND desp-embarque.cod-desp          <> rowObject.cod-desp NO-LOCK:
    
            IF CAN-FIND (FIRST tt-bo-erro
                            WHERE tt-bo-erro.cd-erro = 18848) THEN
                NEXT.
    
            FIND historico-embarque
                WHERE historico-embarque.cod-estabel   = rowObject.cod-estabel
                  AND historico-embarque.embarque      = rowObject.embarque
                  AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                  AND historico-embarque.cod-pto-contr = desp-embarque.cod-pto-contr NO-LOCK NO-ERROR.
    
            IF i-seq-despesa <= i-seq-nacionalizacao AND
               historico-embarque.sequencia > i-seq-nacionalizacao THEN
                NEXT.
    
            IF i-seq-despesa > i-seq-nacionalizacao AND
               historico-embarque.sequencia <= i-seq-nacionalizacao THEN
                NEXT.
        
            if desp-embarque.mo-codigo <> rowObject.mo-codigo then do:          
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i quando_ambas_estiverem_antes_ou_depois_do_ponto_de_nacionalizaá∆o MIM L}.
                ASSIGN c-mensagem = TRIM(RETURN-VALUE).
                create tt-bo-erro.
                assign tt-bo-erro.parametros = string(rowObject.mo-codigo) + "~~" +
                                               string(desp-embarque.mo-codigo) + "~~" +
                                               string(desp-embarque.cod-emitente-desp) + "~~" +
                                               c-mensagem.
                run utp/ut-msgs.p (input "msg",
                                   input 18848,
                                   input string(rowObject.mo-codigo) + "~~" +
                                         string(desp-embarque.mo-codigo) + "~~" +
                                         string(desp-embarque.cod-emitente-desp) + "~~" +
                                         c-mensagem).
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 18848
                       tt-bo-erro.mensagem     = return-value.
                create tt-campo-erro.
                assign tt-campo-erro.campo = "mo-codigo":U.
            end.
    
        END.
        
        find first ordens-embarque
            where ordens-embarque.cod-estabel = rowObject.cod-estabel
              and ordens-embarque.embarque    = rowObject.embarque no-lock no-error.
        if avail ordens-embarque then
            for first cotacao-item fields(cotacao-item.mo-codigo cotacao-item.cod-emitente)
                where cotacao-item.numero-ordem = ordens-embarque.numero-ordem
                  and cotacao-item.cot-aprovada no-lock:
                if cotacao-item.cod-emitente = rowObject.cod-emitente-desp and
                   cotacao-item.mo-codigo   <> rowObject.mo-codigo then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = string(rowObject.mo-codigo) + "~~" +
                                                   string(cotacao-item.mo-codigo).
                    run utp/ut-msgs.p (input "msg",
                                       input 18846,
                                       input string(rowObject.mo-codigo) + "~~" +
                                             string(cotacao-item.mo-codigo)).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 18846
                           tt-bo-erro.mensagem     = return-value.
                    create tt-campo-erro.
                    assign tt-campo-erro.campo = "mo-codigo":U.
                end.
            end.    
    &else
    
        &if '{&bf_mat_versao_ems}' < '2.062' &then
        
        /* Verifica se o Incoterm de rateio esta disponivel no Cad. de Incoterms */
        if  substr(rowObject.char-1,1,3) <> "" then do:
            for first inco-cx fields (cod-incoterm)
                where inco-cx.cod-incoterm = substr(rowObject.char-1,1,3) no-lock: end.

        &else
        
        /* Verifica se o Incoterm de rateio esta disponivel no Cad. de Incoterms */
        if  rowObject.cod-incoterm-rat <> "" then do:
            for first inco-cx fields (cod-incoterm)
                where inco-cx.cod-incoterm = rowObject.cod-incoterm-rat no-lock: end.

        &endif
    
            if  avail inco-cx then do:

                for first desp-incoterm fields (cod-desp)
                    where desp-incoterm.cod-incoterm = inco-cx.cod-incoterm
                    and   desp-incoterm.cod-desp     = rowObject.cod-desp no-lock: end.
                if  avail desp-incoterm then do:

                    /* A incoterm de rateio informada nao deve conter em sua 
                       parametrizacao a propria despesa a ser rateada        */
                    assign i-seq-erro = i-seq-erro + 1.
                    run utp/ut-msgs.p (input "msg",
                                       input 30164,
                                       input inco-cx.cod-incoterm + "~~" +
                                             string(rowObject.cod-desp)).
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 30164
                           tt-bo-erro.mensagem = return-value.

                    run utp/ut-msgs.p (input "help":U,
                                       input 30164,
                                       input inco-cx.cod-incoterm + "~~" + 
                                             string(rowObject.cod-desp)).
                                       
                    assign tt-bo-erro.errorhelp  = return-value
                           tt-bo-erro.parametros = inco-cx.cod-incoterm + "~~" + 
                                                   string(rowObject.cod-desp).

                end.
            end.
            else do:

                /* Nao encontrado incoterm para a chave informada */
                assign i-seq-erro = i-seq-erro + 1.

                {utp/ut-liter.i Incoterm}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.

                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input tt-bo-erro.parametros).
                
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 2
                       tt-bo-erro.mensagem = return-value.
            end.
        end.

        &IF "{&bf_mat_versao_ems}" < "2.04" &THEN
            /* 
            ** Validacao Moeda do Fornecedor
            */
            FIND FIRST historico-embarque
                WHERE historico-embarque.cod-estabel = rowObject.cod-estabel
                  AND historico-embarque.embarque    = rowObject.embarque NO-LOCK NO-ERROR.
            FIND itinerario
                WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.
            FIND historico-embarque
                WHERE historico-embarque.cod-estabel   = rowObject.cod-estabel
                  AND historico-embarque.embarque      = rowObject.embarque
                  AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                  AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK NO-ERROR.
            ASSIGN i-seq-nacionalizacao = historico-embarque.sequencia.

            FIND historico-embarque
                WHERE historico-embarque.cod-estabel   = rowObject.cod-estabel
                  AND historico-embarque.embarque      = rowObject.embarque
                  AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                  AND historico-embarque.cod-pto-contr = rowObject.cod-pto-contr NO-LOCK NO-ERROR.
            ASSIGN i-seq-despesa = historico-embarque.sequencia.

            FOR EACH desp-embarque
                WHERE desp-embarque.cod-estabel       =  rowObject.cod-estabel
                  AND desp-embarque.embarque          =  rowObject.embarque
                  AND desp-embarque.cod-emitente-desp =  rowObject.cod-emitente-desp
                  AND desp-embarque.cod-desp          <> rowObject.cod-desp NO-LOCK:

                IF CAN-FIND (FIRST tt-bo-erro
                                WHERE tt-bo-erro.cd-erro = 18848) THEN
                    NEXT.

                FIND historico-embarque
                    WHERE historico-embarque.cod-estabel   = rowObject.cod-estabel
                      AND historico-embarque.embarque      = rowObject.embarque
                      AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                      AND historico-embarque.cod-pto-contr = desp-embarque.cod-pto-contr NO-LOCK NO-ERROR.

                IF i-seq-despesa <= i-seq-nacionalizacao AND
                   historico-embarque.sequencia > i-seq-nacionalizacao THEN
                    NEXT.

                IF i-seq-despesa > i-seq-nacionalizacao AND
                   historico-embarque.sequencia <= i-seq-nacionalizacao THEN
                    NEXT.

                if desp-embarque.mo-codigo <> rowObject.mo-codigo then do:          
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i quando_ambas_estiverem_antes_ou_depois_do_ponto_de_nacionalizaá∆o MIM L}.
                    ASSIGN c-mensagem = TRIM(RETURN-VALUE).
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = string(rowObject.mo-codigo) + "~~" +
                                                   string(desp-embarque.mo-codigo) + "~~" +
                                                   string(desp-embarque.cod-emitente-desp) + "~~" +
                                                   c-mensagem.
                    run utp/ut-msgs.p (input "msg",
                                       input 18848,
                                       input string(rowObject.mo-codigo) + "~~" +
                                             string(desp-embarque.mo-codigo) + "~~" +
                                             string(desp-embarque.cod-emitente-desp) + "~~" +
                                             c-mensagem).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 18848
                           tt-bo-erro.mensagem     = return-value.
                    create tt-campo-erro.
                    assign tt-campo-erro.campo = "mo-codigo":U.
                end.

            END.

            find first ordens-embarque
                where ordens-embarque.cod-estabel = rowObject.cod-estabel
                  and ordens-embarque.embarque    = rowObject.embarque no-lock no-error.
            if avail ordens-embarque then
                for first cotacao-item fields(cotacao-item.mo-codigo cotacao-item.cod-emitente)
                    where cotacao-item.numero-ordem = ordens-embarque.numero-ordem
                      and cotacao-item.cot-aprovada no-lock:
                    if cotacao-item.cod-emitente = rowObject.cod-emitente-desp and
                       cotacao-item.mo-codigo   <> rowObject.mo-codigo then do:
                        assign i-seq-erro = i-seq-erro + 1.
                        create tt-bo-erro.
                        assign tt-bo-erro.parametros = string(rowObject.mo-codigo) + "~~" +
                                                       string(cotacao-item.mo-codigo).
                        run utp/ut-msgs.p (input "msg",
                                           input 18846,
                                           input string(rowObject.mo-codigo) + "~~" +
                                                 string(cotacao-item.mo-codigo)).
                        assign tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 18846
                               tt-bo-erro.mensagem     = return-value.
                        create tt-campo-erro.
                        assign tt-campo-erro.campo = "mo-codigo":U.
                    end.
                end.    
        &endif
    &endif
    /*fim frank 09/05/05*/

    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        if c-nom-prog-dpc-mg97  <> "" or
           c-nom-prog-appc-mg97 <> "" or
           c-nom-prog-upc-mg97  <> "" then do:
    
            for each tt-epc
                where tt-epc.cod-event = "valida-emitente-mercadoria"
                   or tt-epc.cod-event = "erro-valida-emitente":
                delete tt-epc.
            end.

            {include/i-epc200.i2 &CodEvent="'valida-emitente-mercadoria'"
                                 &CodParameter="'cod-estabel'"
                                 &ValueParameter="RowObject.cod-estabel"}
                                 
            {include/i-epc200.i2 &CodEvent="'valida-emitente-mercadoria'"
                                 &CodParameter="'embarque'"
                                 &ValueParameter="RowObject.embarque"}
            
            {include/i-epc200.i2 &CodEvent="'valida-emitente-mercadoria'"
                                 &CodParameter="'cod-emitente-desp'"
                                 &ValueParameter="string(RowObject.cod-emitente-desp)"}
                                     
            {include/i-epc200.i2 &CodEvent="'valida-emitente-mercadoria'"
                                 &CodParameter="'cod-pto-contr'"
                                 &ValueParameter="string(RowObject.cod-pto-contr)"}
                                     
            {include/i-epc201.i "valida-emitente-mercadoria"}

            /* passa os erros criados na epc para a tt-bo-erro */
            for each  tt-epc
                where tt-epc.cod-event     = "erro-valida-emitente"
                  and tt-epc.cod-parameter = "erros-epc":

                assign i-cod-erro = int(entry(1,tt-epc.val-parameter,"|"))
                       c-des-erro = entry(2,tt-epc.val-parameter,"|") NO-ERROR.

                run utp/ut-msgs.p (input "msg",
                                   i-cod-erro,
                                   input c-des-erro).

                create tt-bo-erro.
                assign i-seq-erro              = i-seq-erro + 1
                       tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = i-cod-erro
                       tt-bo-erro.mensagem     = return-value
                       tt-bo-erro.parametros   = c-des-erro.
            end.

        end.
    &ENDIF
    
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr" 
                                   AND funcao.ativo = YES) THEN DO:
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                IF RowObject.log-forma-preco-compra THEN DO:
            &ELSE
                IF SUBSTRING(RowObject.char-1,4,1) = "1" THEN DO:
            &ENDIF
                    RUN validaFormaPrecoCompra (INPUT TABLE RowObject,
                                                OUTPUT TABLE tt-bo-erro).
                END.
        &ENDIF
    END.

    run endMethod("validateFields":U). 
end procedure.

procedure validateCreate:
    /*
    **  Valida criaá∆o da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    
    run startMethod("validateCreate":U).    
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-error.
    
    if rowObject.cod-estabel = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex desp-embarque cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else do:
        if not can-find(estabelec where estabelec.cod-estabel = rowObject.cod-estabel) then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 777,
                               input rowObject.cod-estabel).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 777
                   tt-bo-erro.mensagem = return-value.
        end. 
    end.
    
    IF CAN-FIND(FIRST decla-import-embarq
                WHERE decla-import-embarq.cod-estab  = rowObject.cod-estabel
                AND   decla-import-embarq.cod-embarq = rowObject.embarque) THEN DO:
        FOR FIRST decla-import-embarq NO-LOCK
            WHERE decla-import-embarq.cod-estab  = rowObject.cod-estabel
            AND   decla-import-embarq.cod-embarq = rowObject.embarque :
            IF CAN-FIND(FIRST despes-decla-import
                        WHERE despes-decla-import.num-di-ems = decla-import-embarq.num-di-ems
                        AND   despes-decla-import.cdn-despes   = rowObject.cod-desp) THEN DO:
                assign i-seq-erro = i-seq-erro + 1.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-despesa AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Despesa" *}
                ASSIGN c-lbl-liter-despesa = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-di AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "DI" *}
                ASSIGN c-lbl-liter-di = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "msg",
                                   input 428,
                                   input c-lbl-liter-despesa + " " + STRING(RowObject.cod-desp) + "~~" + " " + c-lbl-liter-di + ": " + STRING(decla-import-embarq.num-di-ems) + "~~" + c-lbl-liter-despesa + " " + STRING(RowObject.cod-desp) + "~~" + " " + c-lbl-liter-di + ": " + STRING(decla-import-embarq.num-di-ems)).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 428
                       tt-bo-erro.mensagem = return-value.
            END.
        END.
    END.
    
    /* Verifica se possui DI */
    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.
    RUN pi-valida-integracao-di IN h-bocx407 (INPUT RowObject.embarque,   
                                              INPUT RowObject.cod-estabel,
                                              OUTPUT l-possui-di).

    /* Se possuir DI somente ser† poss°vel incluir depesas ap¢s o ponto de nacionalizaá∆o */
    IF l-possui-di THEN DO:
        IF NOT VALID-HANDLE(h-bocx230) THEN
           RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

        /* Busca sequencia do ponto de nacionalizaá∆o */
        RUN retorna-seq-ponto-nacionaliz IN h-bocx407 (INPUT RowObject.embarque,
                                                       INPUT RowObject.cod-estabel,
                                                       OUTPUT i-seq-nacionaliz).
        /* Busca c¢digo do itiner†rio */
        RUN findFirstEmbarque IN h-bocx230 (INPUT RowObject.cod-estabel,    
                                            INPUT RowObject.embarque, 
                                            OUTPUT c-return).
        IF c-return = "" THEN
            RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                          OUTPUT i-cod-itiner).
        
        /* Busca a sequància do ponto da despesa a ser inclu°da */
        RUN findCh-itiner IN h-bocx230(INPUT RowObject.cod-estabel,     
                                       INPUT RowObject.embarque,        
                                       INPUT i-cod-itiner,
                                       INPUT RowObject.cod-pto-contr,
                                       OUTPUT c-return).
        IF c-return = "":U THEN
            RUN getIntField IN h-bocx230 (INPUT "sequencia":U,
                                          OUTPUT i-seq-pto).
        
        /* Se a sequància do ponto da despesa for menor que a do ponto de nacionalizaá∆o cria tt-bo-erro */
        IF i-seq-pto <= i-seq-nacionaliz THEN DO:
            run utp/ut-msgs.p (input "msg",
                               input 54795,
                               input ?).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 54795
                   tt-bo-erro.mensagem     = return-value.
            run utp/ut-msgs.p (input "HELP",
                               input 54795,
                               input ?).
            ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
        END.
    
        IF VALID-HANDLE(h-bocx230) THEN DO:
            DELETE PROCEDURE h-bocx230.
            ASSIGN h-bocx230 = ?.
        END.
    END.

    IF VALID-HANDLE(h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.
    /* ////////// */

    if rowObject.embarque = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex desp-embarque embarque 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.             
    else do:
        if not can-find(embarque-imp 
                            where embarque-imp.cod-estabel = rowObject.cod-estabel
                              and embarque-imp.embarque = rowObject.embarque) then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 17365,
                               input rowObject.embarque + "~~" + rowObject.cod-estabel ).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 17365
                   tt-bo-erro.mensagem = return-value.  
        end.
    end.
    
    if not can-find(itinerario where itinerario.cod-itiner = rowObject.cod-itiner) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex desp-embarque cod-itiner 1}       
        run utp/ut-msgs.p (input "msg",
                           input 47,
                           input return-value + " " + string(rowObject.cod-itiner)).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 47
               tt-bo-erro.mensagem = return-value.
    end.              
    
    if not can-find(pto-contr where pto-contr.cod-pto-contr = rowObject.cod-pto-contr) then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 4586,
                           input rowObject.cod-pto-contr).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 4586
               tt-bo-erro.mensagem = return-value.
    end. 
    
    if not can-find(emitente 
                        where emitente.cod-emitente = rowObject.cod-emitente-desp) then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 3486,
                           input rowObject.cod-emitente-desp).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 3486
               tt-bo-erro.mensagem = return-value.
    end.

    IF CAN-FIND(emitente WHERE emitente.cod-emitente = RowObject.cod-emitente-desp
                         &IF DEFINED(bf-mat-comex) &THEN
                           AND emitente.identific = "C":U
                         &ELSE
                           AND emitente.identific = 1
                         &ENDIF
                         ) THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 8738,
                           INPUT "").
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 8738
               tt-bo-erro.mensagem = TRIM(RETURN-VALUE).
    END.

    run validateFields.    
    
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find first desp-embarque 
            where desp-embarque.cod-estabel  = rowObject.cod-estabel 
              and desp-embarque.embarque     = rowObject.embarque    
              and desp-embarque.cod-itiner   = rowObject.cod-itiner  
              and desp-embarque.cod-desp     = rowObject.cod-desp no-lock no-error.
        if avail desp-embarque then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex desp-embarque 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
    end.
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        find first tt-bo-erro
            no-lock no-error.
    
        if not avail tt-bo-erro then do:
            run executeCreate.
            assign r-chave = to-rowid(return-value).
            RUN pi-grava-siscoserv. /*** Siscoserv ***/
        end.

        IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr" 
                                   AND funcao.ativo = YES) THEN DO:
            IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN                               
                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                    IF rowObject.log-forma-preco-compra THEN DO:
                &ELSE
                    IF SUBSTRING(rowObject.char-1,4,1) = "1" THEN DO:
                &ENDIF
                       RUN RateioFormaPrecoCompra (INPUT TABLE RowObject,
                                                   OUTPUT TABLE tt-desp-rateio,
                                                   OUTPUT TABLE tt-bo-erro).
        
                       FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
                       IF NOT AVAIL tt-bo-erro THEN DO:
                           RUN atualizaFormaPrecoCompra (INPUT TABLE RowObject,
                                                         INPUT TABLE tt-desp-rateio,
                                                         INPUT "ADD":U,
                                                         OUTPUT TABLE tt-bo-erro).
                           IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
                               UNDO, RETURN.
                           END.
                               
                       END.
                       IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
                           UNDO, RETURN.
                       END.
                    END.
            &ENDIF
            END.
        END.
    END.
    

    run endMethod("validateCreate":U).    
end procedure.

PROCEDURE validateUpdate:

    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE INPUT  PARAMETER r-chave AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE c-acao AS CHARACTER  NO-UNDO.
    ASSIGN c-acao = "".
        
    FIND FIRST RowObject NO-ERROR.

    RUN InitializeValidate.
 
    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.
 
    RUN validateFields.
    
    FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
    
    IF NOT AVAIL tt-bo-erro THEN DO:
     TRANS_BLOCK:
     DO TRANSACTION ON ERROR UNDO, LEAVE:
         IF i-pais-impto-usuario <> 1 
             AND NOT l-update-rateio-im3101d THEN DO:
             IF CAN-FIND(FIRST bf-desp-embarque
                         WHERE bf-desp-embarque.cod-estabel       = RowObject.cod-estabel
                           AND bf-desp-embarque.embarque          = RowObject.embarque
                           AND bf-desp-embarque.cod-itiner        = RowObject.cod-itiner 
                           AND bf-desp-embarque.cod-pto-contr     = RowObject.cod-pto-contr
                           AND bf-desp-embarque.cod-desp          = RowObject.cod-desp
                           AND bf-desp-embarque.cod-emitente-desp = RowObject.cod-emitente-desp
                           AND bf-desp-embarque.log-prorate-efetd
                           AND (bf-desp-embarque.cod-cond-pag    <> RowObject.cod-cond-pag OR
                                bf-desp-embarque.mo-codigo       <> RowObject.mo-codigo    OR
                                bf-desp-embarque.val-desp        <> RowObject.val-desp)) THEN DO:

                    RUN utp/ut-msgs.p (INPUT "msg",
                                       INPUT 55683,
                                       INPUT "").
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 55683
                           tt-bo-erro.mensagem = TRIM(RETURN-VALUE).
             END.
         END.
        &IF DEFINED(LOCKCONTROL) > 0 &THEN
            FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave NO-LOCK NO-ERROR.
        &ELSE    
            FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave EXCLUSIVE-LOCK NO-ERROR.
        &ENDIF    

        IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr"
                                   AND funcao.ativo = YES) THEN DO:
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                    IF RowObject.log-forma-preco-compra THEN DO:
                &ELSE
                    IF SUBSTRING(RowObject.char-1,4,1) = "1" THEN DO:
                &ENDIF
                        FIND FIRST bf-desp-embarque
                             WHERE bf-desp-embarque.cod-estabel       = RowObject.cod-estabel
                               AND bf-desp-embarque.embarque          = RowObject.embarque
                               and bf-desp-embarque.cod-itiner        = RowObject.cod-itiner
                               and bf-desp-embarque.cod-pto-contr     = RowObject.cod-pto-contr
                               and bf-desp-embarque.cod-desp          = RowObject.cod-desp
                               and bf-desp-embarque.cod-emitente-desp = RowObject.cod-emitente-desp EXCLUSIVE-LOCK NO-ERROR.
                        
                        IF AVAIL bf-desp-embarque THEN DO:
                            IF RowObject.val-desp > bf-desp-embarque.val-desp THEN
                                ASSIGN c-acao = "ADD":U.
                            ELSE DO:
                                IF RowObject.val-desp < bf-desp-embarque.val-desp THEN
                                    ASSIGN c-acao = "DEL":U.
                            END.
    
                            IF c-acao = "ADD":U OR
                               c-acao = "DEL":U THEN DO:
                                RUN rateioFormaPrecoCompra (INPUT TABLE Rowobject, /*rowobject*/
                                                            OUTPUT TABLE tt-desp-rateio-old,
                                                            OUTPUT TABLE tt-bo-erro).
                                IF CAN-FIND(FIRST tt-bo-erro) THEN
                                        UNDO, RETURN.
                            END.
                        END.
                    END.
            &ENDIF
            /* Foi desmarcada a opcao Forma preco compra e o atualiza valor caso modificado ou nao */
            FIND FIRST bf-desp-embarque
                 WHERE bf-desp-embarque.cod-estabel       = RowObject.cod-estabel
                   AND bf-desp-embarque.embarque          = RowObject.embarque
                   and bf-desp-embarque.cod-itiner        = RowObject.cod-itiner
                   and bf-desp-embarque.cod-pto-contr     = RowObject.cod-pto-contr
                   and bf-desp-embarque.cod-desp          = RowObject.cod-desp
                   and bf-desp-embarque.cod-emitente-desp = RowObject.cod-emitente-desp NO-LOCK NO-ERROR.

            IF (AVAIL bf-desp-embarque AND TRIM(SUBSTRING(bf-desp-embarque.char-1,4,1)) = "1")
                AND c-acao = "" THEN DO:

                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                    IF NOT RowObject.log-forma-preco-compra THEN DO:
                &ELSE
                    IF SUBSTRING(RowObject.char-1,4,1) = "0"  OR 
                       SUBSTRING(RowObject.char-1,4,1) = "" THEN DO:
                &ENDIF
                        RUN rateioFormaPrecoCompra (INPUT TABLE rowobject,
                                                    OUTPUT TABLE tt-desp-rateio-old,
                                                    OUTPUT TABLE tt-bo-erro).
    
                        FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
                        IF NOT AVAIL tt-bo-erro THEN DO:
                            RUN atualizaFormaPrecoCompra (INPUT TABLE RowObject,
                                                          INPUT TABLE tt-desp-rateio-old,
                                                          INPUT "DEL":U,
                                                          OUTPUT TABLE tt-bo-erro).
                            IF CAN-FIND(FIRST tt-bo-erro) THEN
                                UNDO TRANS_BLOCK, RETURN "NOK":U.
                        END.
                        IF CAN-FIND(FIRST tt-bo-erro) THEN
                            UNDO TRANS_BLOCK, RETURN "NOK":U.
                    END.
            END.
        END. /*funcao*/

        find first tt-bo-erro no-lock no-error.
        if not avail tt-bo-erro then do:
            RUN executeUpdate.
            assign r-chave = to-rowid(return-value).
        end.

        IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr"
                                   AND funcao.ativo = YES) THEN DO:
             &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
                /*Foi marcada a opcao Forma Preco Compra, porÇm nao foi alterado o valor da despesa*/
                IF c-acao = "" THEN DO:
                   &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                        IF {&TABLE-NAME}.log-forma-preco-compra THEN DO:
                   &ELSE
                        IF SUBSTRING({&TABLE-NAME}.char-1,4,1) = "1" THEN DO:
                   &ENDIF
                           RUN RateioFormaPrecoCompra (INPUT TABLE RowObject,
                                                       OUTPUT TABLE tt-desp-rateio,
                                                       OUTPUT TABLE tt-bo-erro).
                           FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
                           IF NOT AVAIL tt-bo-erro THEN DO:
                               RUN atualizaFormaPrecoCompra (INPUT TABLE RowObject,
                                                             INPUT TABLE tt-desp-rateio,
                                                             INPUT "ADD":U,
                                                             OUTPUT TABLE tt-bo-erro).
                               IF CAN-FIND(FIRST tt-bo-erro) THEN
                                    UNDO TRANS_BLOCK, RETURN "NOK":U.
                           END.
                           IF CAN-FIND(FIRST tt-bo-erro) THEN
                                    UNDO TRANS_BLOCK, RETURN "NOK":U.
                        END.
                END.
            
                IF c-acao = "ADD":U OR
                   c-acao = "DEL":U THEN DO:
                     RUN rateioFormaPrecoCompra (INPUT TABLE RowObject,
                                                 OUTPUT TABLE tt-desp-rateio-aux,
                                                 OUTPUT TABLE tt-bo-erro).
        
                     FIND FIRST tt-bo-erro NO-ERROR.
                     IF NOT AVAIL tt-bo-erro THEN DO:
                         FOR EACH tt-desp-rateio-aux
                             WHERE tt-desp-rateio-aux.cod-desp = RowObject.cod-desp:
    
                             FIND tt-desp-rateio
                                  WHERE tt-desp-rateio.numero-ordem = tt-desp-rateio-aux.numero-ordem
                                    AND tt-desp-rateio.parcela      = tt-desp-rateio-aux.parcela     
                                    AND tt-desp-rateio.cod-desp     = tt-desp-rateio-aux.cod-desp    NO-ERROR.
    
                             FIND ordens-embarque
                                 WHERE ordens-embarque.cod-estabel  = RowObject.cod-estabel
                                   AND ordens-embarque.embarque     = RowObject.embarque  
                                   AND ordens-embarque.numero-ordem = tt-desp-rateio.numero-ordem
                                   AND ordens-embarque.parcela      = tt-desp-rateio.parcela NO-LOCK NO-ERROR.
    
                             FIND tt-desp-rateio-old
                                  WHERE tt-desp-rateio-old.numero-ordem = tt-desp-rateio-aux.numero-ordem
                                    AND tt-desp-rateio-old.parcela      = tt-desp-rateio-aux.parcela     
                                    AND tt-desp-rateio-old.cod-desp     = tt-desp-rateio-aux.cod-desp    NO-ERROR.
                             
                             IF AVAIL tt-desp-rateio-old THEN DO:
                                 IF tt-desp-rateio-old.val-desp <> tt-desp-rateio-aux.val-desp THEN DO:
                                     IF  c-acao = "ADD":U THEN DO:
                                         ASSIGN tt-desp-rateio-aux.val-desp-mo  = tt-desp-rateio-aux.val-desp-mo - 
                                                                                  tt-desp-rateio-old.val-desp-mo
                                                tt-desp-rateio.val-desp-mo      = tt-desp-rateio-aux.val-desp-mo
                                                tt-desp-rateio.val-desp-unit-mo = tt-desp-rateio.val-desp-mo.
                                             
                                     END.
                                     ELSE 
                                         IF c-acao = "DEL":U THEN DO:
                                             ASSIGN tt-desp-rateio-old.val-desp-mo = tt-desp-rateio-old.val-desp-mo - 
                                                                                  tt-desp-rateio-aux.val-desp-mo
                                                    tt-desp-rateio.val-desp-mo = tt-desp-rateio-old.val-desp-mo
                                                    tt-desp-rateio.val-desp-unit-mo = tt-desp-rateio.val-desp-mo.
                                         END.
                                 END.
                             END.
    
                             FIND FIRST desp-imp
                                 WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp NO-LOCK NO-ERROR.
    
                             IF desp-imp.tipo <> 1 THEN DO: /*Diferente de Fixo*/
                                 ASSIGN tt-desp-rateio.val-desp-unit    = tt-desp-rateio.val-desp    / ordens-embarque.qt-do-forn
                                        tt-desp-rateio.val-desp-unit-mo = tt-desp-rateio.val-desp-mo / ordens-embarque.qt-do-forn.     
                             END.
                             
                         END.
                         RUN atualizaFormaPrecoCompra (INPUT TABLE RowObject,
                                                       INPUT TABLE tt-desp-rateio,
                                                       INPUT c-acao,
                                                       OUTPUT TABLE tt-bo-erro).
    
                         IF CAN-FIND(FIRST tt-bo-erro) THEN
                             UNDO TRANS_BLOCK, RETURN "NOK":U.
                     END.
                     IF CAN-FIND(FIRST tt-bo-erro) THEN
                         UNDO TRANS_BLOCK, RETURN "NOK":U.
                END.
            &ENDIF
        END.
    END.
END. /*tt-bo-erro*/
    
    
END PROCEDURE.

PROCEDURE validateDelete:

    DEFINE INPUT-OUTPUT PARAMETER r-chave AS ROWID.
    DEFINE OUTPUT       PARAMETER TABLE FOR tt-bo-erro.
 
    DEFINE VARIABLE h-bocx00451      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-possui-antecip AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-lb-forn-desp   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lb-del-desp    AS CHARACTER   NO-UNDO.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    RUN InitializeValidate.

    &IF DEFINED(LOCKCONTROL) > 0 &THEN
        FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave NO-LOCK NO-ERROR.
    &ELSE
        FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave EXCLUSIVE-LOCK NO-ERROR.
    &ENDIF    
    
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr"
                               AND funcao.ativo = YES) THEN DO:
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                 IF {&TABLE-NAME}.log-forma-preco-compra THEN DO:
            &ELSE
                 IF SUBSTRING({&TABLE-NAME}.char-1,4,1) = "1" THEN DO:
            &ENDIF
                    RUN RateioFormaPrecoCompra (INPUT TABLE RowObject,
                                                OUTPUT TABLE tt-desp-rateio-aux,
                                                OUTPUT TABLE tt-bo-erro).
                    FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-bo-erro THEN DO:
                        RUN atualizaFormaPrecoCompra (INPUT TABLE RowObject,
                                                      INPUT TABLE tt-desp-rateio-aux,
                                                      INPUT "DEL":U,
                                                      OUTPUT TABLE tt-bo-erro).
                    END.
                    IF CAN-FIND(FIRST tt-bo-erro) THEN
                        UNDO, RETURN "NOK":U.
                 END.
          &ENDIF
    END.
        
    IF AVAIL {&TABLE-NAME} THEN DO:
        /*** Siscoserv ***/
        IF NOT VALID-HANDLE(h-cdapi050) THEN
            RUN cdp/cdapi050 PERSISTENT SET h-cdapi050.

        RUN pi-siscoserv-ativo IN h-cdapi050.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN pi-apaga-despes-import-sis IN h-cdapi050 (INPUT rowObject.cod-estabel,      
                                                          INPUT rowObject.embarque,         
                                                          INPUT rowObject.cod-itiner,       
                                                          INPUT rowObject.cod-pto-contr,    
                                                          INPUT rowObject.cod-desp,         
                                                          INPUT rowObject.cod-emitente-desp).
        END.
        IF VALID-HANDLE(h-cdapi050) THEN DO:
            DELETE PROCEDURE h-cdapi050.
            ASSIGN h-cdapi050 = ?.
        END.
        /*** Siscoserv ***/

        
        /*** IFRIC ***/
        IF CAN-FIND(FIRST funcao 
                    WHERE funcao.cd-funcao = "spp-ifric22":U 
                      AND funcao.ativo) THEN DO:
                
            RUN cxbo/bocx00451.p PERSISTENT SET h-bocx00451.
    
            RUN piVerificaAntecipFornec IN h-bocx00451(INPUT rowObject.cod-estabel,
                                                       INPUT rowObject.embarque,
                                                       INPUT rowObject.cod-emitente-desp,
                                                       OUTPUT l-possui-antecip).
            DELETE PROCEDURE h-bocx00451.
            ASSIGN h-bocx00451 = ?.

            IF l-possui-antecip THEN DO:
                 ASSIGN i-seq-erro = i-seq-erro + 1.
    
                 {utp/ut-liter.i "fornecedor_da_despesa"}
                 ASSIGN c-lb-forn-desp = TRIM(RETURN-VALUE).
    
                 {utp/ut-liter.i "eliminar_a_despesa"}
                 ASSIGN c-lb-del-desp = TRIM(RETURN-VALUE).
    
    
                 RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 55823,
                                   INPUT c-lb-forn-desp + "~~":U + c-lb-del-desp).
                 CREATE tt-bo-erro.
                 ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                        tt-bo-erro.cd-erro  = 55823
                        tt-bo-erro.errorsubtype = "ERROR":U
                        tt-bo-erro.mensagem = TRIM(RETURN-VALUE)
                        tt-bo-erro.parametros = c-lb-forn-desp + "~~":U + c-lb-del-desp.
                 UNDO, RETURN "NOK":U.
            END.
        END.
        /*** IFRIC ***/

        if i-pais-impto-usuario = 9 /*Paraguay*/ then do:
            find first despes-embarq-internac
                 where despes-embarq-internac.cod-estabel       = {&TABLE-NAME}.cod-estabel       
                   and despes-embarq-internac.embarque          = {&TABLE-NAME}.embarque          
                   and despes-embarq-internac.cod-itiner        = {&TABLE-NAME}.cod-itiner        
                   and despes-embarq-internac.cod-pto-contr     = {&TABLE-NAME}.cod-pto-contr     
                   and despes-embarq-internac.cod-desp          = {&TABLE-NAME}.cod-desp          
                   and despes-embarq-internac.cod-emitente-desp = {&TABLE-NAME}.cod-emitente-desp exclusive-lock no-error.
            if available despes-embarq-internac then
                delete despes-embarq-internac.
        end.

        RUN executeDelete.

    END.
 
    IF l-query THEN GET NEXT {&QUERY-NAME} NO-LOCK NO-WAIT.
    ELSE FIND NEXT {&TABLE-NAME} NO-LOCK NO-ERROR.

    IF NOT AVAIL {&TABLE-NAME} THEN DO:
       IF l-query THEN GET PREV {&QUERY-NAME} NO-LOCK NO-WAIT.
       ELSE FIND PREV {&TABLE-NAME} NO-LOCK NO-ERROR.
    END.
    
    ASSIGN r-chave = ROWID({&TABLE-NAME}).
    
    RETURN "".
END PROCEDURE.



procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "cod-estabel"   then c-value = RowObject.cod-estabel.
        when "embarque"      then c-value = RowObject.embarque.
        when "char-1"      then c-value = RowObject.char-1.
        when "char-2"      then c-value = RowObject.char-2.
        when "check-sum"   then c-value = RowObject.check-sum.
        WHEN "descricao" THEN c-value = RowObject.descricao.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:        
        when "val-desp"   then c-value = RowObject.val-desp.
        when "dec-1"      then c-value = RowObject.dec-1.
        when "dec-2"      then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer. 
    case c-field:
        when "cod-itiner"        then c-value = RowObject.cod-itiner.
        when "cod-pto-contr"     then c-value = RowObject.cod-pto-contr.
        when "cod-desp"          then c-value = RowObject.cod-desp.
        when "cod-emitente-desp" then c-value = RowObject.cod-emitente-desp.       
        when "cod-cond-pag"      then c-value = RowObject.cod-cond-pag.
        when "mo-codigo" then c-value = RowObject.mo-codigo.
        when "int-1"     then c-value = RowObject.int-1.
        when "int-2"     then c-value = RowObject.int-2.        
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1"    then c-value = RowObject.data-1.
        when "data-2"    then c-value = RowObject.data-2.        
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.        
        when "log-prorate-efetd" then c-value = RowObject.log-prorate-efetd.        
        otherwise return error.
    end case.
end procedure.
 
procedure validaValorDespesa:
    /*verifica se o valor da despesa foi modificado para: - menor (da erro),
                                                          - maior (desmarca recebido)*/
    define input        parameter d-val-desp-ant         as dec no-undo.
    define input        parameter d-val-desp-atual       like desp-embarque.val-desp no-undo.
    define input-output parameter l-desp-recebida        like desp-embarque.log-1 no-undo.
    define output parameter table for RowErrors.
    
    for each RowErrors:
        delete RowErrors.
    end.

    assign i-seq-erro = i-seq-erro + 1.
    if d-val-desp-ant > d-val-desp-atual then do:
        create RowErrors.
        assign RowErrors.ErrorNumber = 29365
               RowErrors.ErrorType   = "EMS"
               RowErrors.ErrorSubType="ERROR"
               RowErrors.ErrorParameters="''".
    end.
    else if d-val-desp-ant < d-val-desp-atual then do:
        create RowErrors.
        assign RowErrors.ErrorNumber = 29366
               RowErrors.ErrorType   ="EMS"
               RowErrors.ErrorSubType="ERROR"
               RowErrors.ErrorParameters=string(d-val-desp-atual - d-val-desp-ant).
        assign l-desp-recebida = no.
    end.
    
    return "OK":U.
end procedure.

procedure mostraDespesaRecebida:
    /*O campo despesa Recebida somente ficar† vis°vel se o ponto de controle de despesa tiver
    a sua sequencia maior que a sequencia do ponto de nacionalizaá∆o*/
    def input parameter r-hist-estoq as rowid no-undo.

    def var i-seq-desp-atual    as int init 0  no-undo.
    def var c-existe-itinerario as char  init "" no-undo.
    def var i-pto-desembarque   as int init 0  no-undo.
    def var c-existe-hist-emb   as char  init "" no-undo.
    def var i-seq-desp-nacional as int init 0  no-undo.
    def var c-estabel           as char        no-undo.
    def var c-embarque          as char        no-undo.
    def var i-cod-itiner        as int         no-undo.

    if not valid-handle(hDBOhist-embarque) or
        hDBOhist-embarque:Type <> "PROCEDURE":U or
        hDBOhist-embarque:File-name <> "cxbo/bocx230.p":U THEN DO:
        run cxbo/bocx230.p persistent set hDBOhist-embarque.
    end.
    if not valid-handle(hDBOitinerario) or
        hDBOitinerario:Type <> "PROCEDURE":U or
        hDBOitinerario:File-name <> "cxbo/bocx115.p":U THEN DO:
        run cxbo/bocx115.p persistent set hDBOitinerario.
    end.

    /*verificando a sequencia do pto de controle*/
    if valid-handle(hDBOhist-embarque) then do:
        run findRowid in hDBOhist-embarque (input r-hist-estoq).
        run getIntField in hDBOhist-embarque (input "sequencia":U, output i-seq-desp-atual) no-error.
        run getCharField in hDBOhist-embarque (input "cod-estabel":U, output c-estabel) no-error.
        run getCharField in hDBOhist-embarque (input "embarque":U, output c-embarque) no-error.
        run getIntField in hDBOhist-embarque  (input "cod-itiner":U, output i-cod-itiner) no-error.
    
        /*verificando a sequencia da nacionalizaá∆o*/
        if valid-handle(hDBOitinerario) then do:
            run findcodigo in hDBOitinerario (input i-cod-itiner, output c-existe-itinerario) no-error.
            if c-existe-itinerario = "" then
                run getIntField in hDBOitinerario (input "pto-desembarque":U, output i-pto-desembarque) no-error.
            run destroy IN hDBOitinerario NO-ERROR.
            assign hDBOitinerario = ?.
        end.
        
        run findCh-itiner in hDBOhist-embarque (input  c-estabel,
                                                input  c-embarque,
                                                input  i-cod-itiner,
                                                input  i-pto-desembarque,
                                                output c-existe-hist-emb) no-error.
        if c-existe-hist-emb = "" then 
            run getIntField in hDBOhist-embarque (input "sequencia":U, output i-seq-desp-nacional) no-error.
        run destroy IN hDBOhist-embarque NO-ERROR.
        assign hDBOhist-embarque = ?.
    end.

    if i-seq-desp-atual > i-seq-desp-nacional then
        return "OK":U.
    else
        return "NOK":U.
end procedure.

procedure piRetornaSitDespesa:

    def input  param p-embarque         like embarque-imp.embarque           no-undo.  
    def input  param pCod-estabel       like embarque-imp.cod-estabel        no-undo.
    def input  param pCod-itiner        as integer                           no-undo.      
    def input  param pCod-pt-contr      like desp-embarque.cod-pto-contr     no-undo.      
    def input  param pCod-desp          like desp-embarque.cod-desp          no-undo.
    def input  param pCod-emitente-desp like desp-embarque.cod-emitente-desp no-undo.
    def output param p-sit-desp         as char format "X(03)"               no-undo.      
    
    def var c-exist                 as char init ""                   no-undo.
    def var i-pt-desemb             like itinerario.pto-desembarque   no-undo.
    def var i-sequencia-pto         like historico-embarque.sequencia no-undo.
    def var i-sequencia-desembarque like historico-embarque.sequencia no-undo.
        
    /* Inicializa BO Itiner†rio */
    if not valid-handle(hDBOitinerario) or
        hDBOitinerario:type <> "PROCEDURE":U or
        hDBOitinerario:file-name <> "cxbo/bocx115.p":U then do:
        run cxbo/bocx115.p persistent set hDBOitinerario.
    end.
    
    /* Inicializa BO historico-embarque */
    if not valid-handle(hDBOhist-embarque) or
        hDBOhist-embarque:Type <> "PROCEDURE":U or
        hDBOhist-embarque:File-name <> "cxbo/bocx230.p":U then do:
        run cxbo/bocx230.p persistent set hDBOhist-embarque.
    end.

    /* Verifica sequencia do ponto de controle */
    if valid-handle(hDBOhist-embarque) then do:
        assign c-exist = "".
        run findFirstEmbarque in hDBOhist-embarque (input  pCod-estabel,
                                                    input  p-embarque,
                                                    output c-exist) no-error.

        if c-exist = "" then do:
            assign c-exist = "".
            run findCh-itiner in hDBOhist-embarque (input  p-embarque,
                                                    input  pCod-itiner,
                                                    input  pCod-pt-contr,
                                                    output c-exist) no-error.
            if c-exist = "" then
                run getIntField in hDBOhist-embarque (input  "sequencia",
                                                      output i-sequencia-pto) no-error.
        end.
    end.

    /* Procura pelo ponto de desembarque (nacionalizaá∆o) na tabela Itiner†rio */
    if valid-handle(hDBOitinerario) then do:
        assign c-exist = "".
        run findcodigo in hDBOitinerario (input  pCod-itiner,
                                          output c-exist) no-error.

        if c-exist = "" then
            run getIntField in hDBOitinerario (input  "pto-desembarque",
                                               output i-pt-desemb) no-error.
    end.
    
    /*Verifica sequencia do ponto de desembarque (nacionalizaá∆o)*/
    if valid-handle(hDBOhist-embarque) then do:
        assign c-exist = "".
        run findCh-itiner in hDBOhist-embarque (input  p-embarque,
                                                input  pCod-itiner,
                                                input  i-pt-desemb,
                                                output c-exist) no-error.
        if c-exist = "" then
            run getIntField in hDBOhist-embarque (input  "sequencia",
                                                  output i-sequencia-desembarque) no-error.
    end.

    /*Se a sequencia do ponto de controle (i-sequencia-pto) for maior que a do 
    ponto de desembarque/nacionalizaá∆o (i-sequencia-desembarque) ent∆o as despesas ser∆o da nota 
    fiscal complementar e ser† verificado se ela j† fora recebida ou n∆o pelo campo desp-embarque.log-1 
    atÇ a release 205 e desp-embarque.log-despes-ja-recbda*/
    if i-sequencia-pto > i-sequencia-desembarque then do:
        find desp-embarque 
            where desp-embarque.cod-estabel       = pCod-estabel
            and   desp-embarque.embarque          = p-embarque
            and   desp-embarque.cod-itiner        = pCod-itiner
            and   desp-embarque.cod-pto-contr     = pCod-pt-contr
            and   desp-embarque.cod-desp          = pCod-desp
            and   desp-embarque.cod-emitente-desp = pCod-emitente-desp no-lock no-error.
        
        if avail desp-embarque then do:
            &if "{&bf_mat_versao_ems}" >= "2.04" and "{&bf_mat_versao_ems}" < "2.06" &then
                if desp-embarque.log-1 then
                    assign p-sit-desp = "Sim".
                ELSE 
                    assign p-sit-desp = "N∆o".
               
            &elseif "{&bf_mat_versao_ems}" >= "2.06" &then
                if desp-embarque.log-despes-ja-recbda then
                    assign p-sit-desp = "Sim".
                else 
                    assign p-sit-desp = "N∆o".
            &endif
        end.
    end.
    else
        assign p-sit-desp = "?". /*Se o ponto de controle for menor que o ponto de nacionalizaá∆o ent∆o o campo receber† "" */

        if valid-handle(hDBOitinerario) then
            delete procedure hDBOitinerario.
        assign hDBOitinerario = ?.

        if valid-handle(hDBOhist-embarque) then
            delete procedure hDBOhist-embarque.
        assign hDBOhist-embarque = ?.
           
end procedure.

procedure pi-habilita-incoterm-rateio:
/*****************************************************************************
  Objetivo:
  
  O campo sera habilitado quando a despesa for parametrizada para ser rateada
  por valor (despesa tipo: valor fixo, valor informado, taxa sobre distancia,
  taxa sobre dias, adicional sobre valor e formula) e a despesa for diferente
  de imposto (todos os releases: II / a partir da 2.06B: 
  II, IPI, PIS, COFINS e ICMS.
*****************************************************************************/
    define input  parameter i-cod-desp    as integer   format ">>,>>9":U no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
    define input  parameter c-cod-estabel as character format "x(05)":U   no-undo.
&ELSE
    define input  parameter c-cod-estabel as character format "x(3)":U   no-undo.
&ENDIF
    define output parameter l-habilita    as logical                     no-undo.

    for first desp-imp fields (cod-desp tipo)
        where desp-imp.cod-desp = i-cod-desp no-lock: end.

    for first param-imp fields (cdn-despes-impto-ipi    cdn-despes-impto-pis 
                                cdn-despes-impto-cofins cdn-despes-impto-icms char-1) 
                        where param-imp.cod-estabel = c-cod-estabel NO-LOCK. end.
        
    IF l-nt2024002 THEN DO:
        FIND FIRST param-imp-trib
             WHERE param-imp-trib.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL param-imp      AND
           AVAIL param-imp-trib AND
           AVAIL desp-imp       AND 
           CAN-DO("1,2,4,5,7,8", STRING(desp-imp.tipo))                       AND  /* Val Fixo,Val Inform,Tx Distancia,Tx Dias,Adic Valor,Formula respectivamente */
           STRING(desp-imp.cod-desp) <> TRIM(SUBSTR(param-imp.char-1,21,20))  AND  /* imposto importacao */
           desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi                AND
           desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis                AND 
           desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins             AND 
           desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms               AND
           desp-imp.cod-desp <> param-imp-trib.cdn-despes-impto-IBSUF         AND           
           desp-imp.cod-desp <> param-imp-trib.cdn-despes-impto-CBS           AND
           desp-imp.cod-desp <> param-imp-trib.cdn-despes-impto-IS            AND
           desp-imp.cod-desp <> param-imp-trib.cdn-despes-impto-IBSMun        THEN 
           ASSIGN l-habilita = YES.
        ELSE
           ASSIGN l-habilita = NO.
    END.
    ELSE DO:
        IF avail desp-imp                              
           and avail param-imp                             
           and can-do("1,2,4,5,7,8", string(desp-imp.tipo)) /* Val Fixo,Val Inform,Tx Distancia,Tx Dias,Adic Valor,Formula respectivamente */
           and (string(desp-imp.cod-desp) <> trim(substr(param-imp.char-1,21,20)) /* imposto importacao */             
           and desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi    
           and desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis    
           and desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins 
           and desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms) then 
            assign l-habilita = yes.
        else 
            assign l-habilita = no.
    END.

end procedure.

PROCEDURE validaFormaPrecoCompra:

    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEF VAR i-seq-nacionalizacao AS INTEGER NO-UNDO.
    DEF VAR i-seq-despesa        AS INTEGER NO-UNDO.

    FIND FIRST RowObject NO-ERROR.
    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
        FOR EACH RowErrors:
            DELETE RowErrors.
        END.
        ASSIGN i-seq-erro = 0.
    
        IF AVAIL RowObject THEN DO:
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
              IF RowObject.log-forma-preco-compra THEN DO:
            &ELSE
              &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
                IF SUBSTRING(RowObject.char-1,4,1) = "1" THEN DO:
              &ENDIF
            &ENDIF
                  FIND FIRST ordens-embarque
                       WHERE ordens-embarque.cod-estabel = RowObject.cod-estabel
                         AND ordens-embarque.embarque    = RowObject.embarque NO-LOCK NO-ERROR.
                  IF AVAIL ordens-embarque THEN DO:
                      FIND ordem-compra
                          WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
                      IF AVAIL ordem-compra THEN DO:
                          IF ordem-compra.nr-contrato <> 0 THEN DO:
                              ASSIGN i-seq-erro = i-seq-erro + 1.
                              RUN utp/ut-msgs.p (INPUT "msg":U,
                                                 INPUT 31447,
                           		                 INPUT "").
    
                              CREATE RowErrors.
                              ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                                     RowErrors.ErrorNumber      = 31447
                                     RowErrors.ErrorType        = "EMS":U
                                     RowErrors.ErrorSubType     = "ERROR":U
                                     RowErrors.ErrorDescription = TRIM(RETURN-VALUE).
                          END.
                      END.
                      FIND FIRST ordem-compra 
                           WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
                      IF AVAIL ordem-compra THEN DO:
                          IF ordem-compra.mo-codigo <> RowObject.mo-codigo THEN DO:
                              ASSIGN i-seq-erro = i-seq-erro + 1.
                              RUN utp/ut-msgs.p (INPUT "msg":U,
                                                 INPUT 31448,
                                                 INPUT "").
    
                              CREATE RowErrors.
                              ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                                     RowErrors.ErrorNumber      = 31448
                                     RowErrors.ErrorType        = "EMS":U
                                     RowErrors.ErrorSubType     = "ERROR":U
                                     RowErrors.ErrorDescription = TRIM(RETURN-VALUE).
            
                          END.
                      END.
                      FIND FIRST historico-embarque
                           WHERE historico-embarque.cod-estabel = RowObject.cod-estabel
                             AND historico-embarque.embarque    = RowObject.embarque    NO-LOCK NO-ERROR.
                      IF AVAIL historico-embarque THEN DO:
                          FOR FIRST itinerario FIELDS(cod-itiner)
                             WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK,
                              FIRST embarque-imp FIELDS(cdn-pto-desembar) NO-LOCK
                              WHERE embarque-imp.cod-estabel = RowObject.cod-estabel
                                AND embarque-imp.embarque    = RowObject.embarque:

                              FIND historico-embarque
                                 WHERE historico-embarque.cod-estabel   = RowObject.cod-estabel
                                   AND historico-embarque.embarque      = RowObject.embarque
                                   AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                                   AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK NO-ERROR.

                              ASSIGN i-seq-nacionalizacao = historico-embarque.sequencia.
    
                              FIND historico-embarque
                                 WHERE historico-embarque.cod-estabel   = RowObject.cod-estabel
                                   AND historico-embarque.embarque      = RowObject.embarque
                                   AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                                   AND historico-embarque.cod-pto-contr = RowObject.cod-pto-contr NO-LOCK NO-ERROR.

                              ASSIGN i-seq-despesa = historico-embarque.sequencia.
    
                              IF i-seq-despesa > i-seq-nacionalizacao THEN DO:
                                  ASSIGN i-seq-erro = i-seq-erro + 1.
                                  RUN utp/ut-msgs.p (INPUT "msg":U,
                                                     INPUT 31449,
                                                     INPUT "").
        
                                  CREATE RowErrors.
                                  ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                                         RowErrors.ErrorNumber      = 31449
                                         RowErrors.ErrorType        = "EMS":U
                                         RowErrors.ErrorSubType     = "ERROR":U
                                         RowErrors.ErrorDescription = TRIM(RETURN-VALUE).
                                  
                              END.
                          END.
                      END.
                  END. /*ordens-embarque*/
                  FIND FIRST desp-imp
                       WHERE desp-imp.cod-desp = RowObject.cod-desp NO-LOCK NO-ERROR.
                  IF AVAIL desp-imp THEN DO:
                      IF NOT desp-imp.inc-val-frete  AND
                         NOT desp-imp.inc-val-seguro AND
                         NOT desp-imp.inc-val-embal  AND 
                         NOT desp-imp.inc-val-outras-desp THEN DO:

                          ASSIGN i-seq-erro = i-seq-erro + 1.
                          RUN utp/ut-msgs.p (INPUT "msg":U,
                                             INPUT 31450,
                                             INPUT "").

                          CREATE RowErrors.
                          ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                                 RowErrors.ErrorNumber      = 31450
                                 RowErrors.ErrorType        = "EMS":U
                                 RowErrors.ErrorSubType     = "ERROR":U
                                 RowErrors.ErrorDescription = TRIM(RETURN-VALUE).

                      END.
                  END.
                  FIND FIRST ordens-embarque
                       WHERE ordens-embarque.cod-estabel = RowObject.cod-estabel
                         AND ordens-embarque.embarque    = RowObject.embarque NO-LOCK NO-ERROR.
                  IF AVAIL ordens-embarque THEN DO:
                      FOR FIRST cotacao-item 
                          WHERE cotacao-item.numero-ordem = ordens-embarque.numero-ordem
                            AND cotacao-item.cot-aprovada NO-LOCK:
                            {ccp/cc9019.i50}

                            &IF DEFINED(bf-mat-comex) &THEN
                            &ELSE
                              {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                              {ccp/cc9019.i51 "yes"}
                            &ENDIF

                        FIND FIRST cotacao-item-cex
                             WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                               AND cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                               AND cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
                               AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                               AND cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
                               AND cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50 NO-LOCK NO-ERROR.
                          IF AVAIL cotacao-item-cex THEN
                              IF RowObject.cod-desp = cotacao-item-cex.cod-desp THEN DO:
                                  RUN utp/ut-msgs.p (INPUT "msg":U,
                                                     INPUT 31451,
                                                     INPUT "").
    
                                  CREATE RowErrors.
                                  ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                                         RowErrors.ErrorNumber      = 31451
                                         RowErrors.ErrorType        = "EMS":U
                                         RowErrors.ErrorSubType     = "ERROR":U
                                         RowErrors.ErrorDescription = TRIM(RETURN-VALUE).
    
                              END.
                          END.
                  END.
              END.
          END.
    &ENDIF

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE rateioFormaPrecoCompra:

    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-desp-rateio.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE c-class-fiscal    LIKE classif-fisc.class-fiscal NO-UNDO.
    DEFINE VARIABLE de-preco-total    LIKE item-doc-est.preco-total  EXTENT 0 NO-UNDO.
    DEFINE VARIABLE de-preco-unit-mo  LIKE item-doc-est.preco-total  EXTENT 0 NO-UNDO.
    DEFINE VARIABLE de-preco-total-mo LIKE item-doc-est.preco-total  EXTENT 0 NO-UNDO.
    DEFINE VARIABLE l-gravado         AS   LOGICAL                   NO-UNDO.
    DEFINE VARIABLE de-aliquota-ipi   LIKE ITEM.aliquota-ipi         NO-UNDO.
    DEFINE VARIABLE c-cod-depos       LIKE ordem-compra.dep-almoxar  NO-UNDO.
    DEFINE VARIABLE l-create-itens    AS   LOGICAL                   NO-UNDO.
    &IF DEFINED(bf-mat-comex) &THEN
    &ELSE
        DEFINE VARIABLE c-deposito-pad    LIKE ITEM.deposito-pad     NO-UNDO.
        DEFINE VARIABLE c-cod-localiz     LIKE ITEM.cod-localiz      NO-UNDO.    
    &ENDIF
    
    FIND FIRST RowObject NO-ERROR.

    IF CAN-FIND(FIRST tt-itens) THEN
        ASSIGN l-create-itens = YES.

    DEFINE VARIABLE h-im0091 AS HANDLE NO-UNDO.
    
    /* Rateio das despesas informadas para o embarque */
    RUN imp/im0091.p PERSISTENT SET h-im0091.

    RUN setaValorinicial IN h-im0091 (INPUT TODAY,
                                      INPUT RowObject.cod-estabel).

    FIND FIRST ordens-embarque
         WHERE ordens-embarque.cod-estabel = RowObject.cod-estabel
           AND ordens-embarque.embarque    = RowObject.embarque   NO-LOCK NO-ERROR.

    IF AVAIL ordens-embarque THEN DO:
        ASSIGN c-class-fiscal    = ""
               de-preco-total    = 0
               de-preco-total-mo = 0.

        {ccp/cc9019.i50} /* include tratamento atributo livre cotacao-item.char-1 */
        {cxbo/bocx225e.i1} /* vari†veis atributo livre ordens-embarque */
        {cxbo/bocx225e.i2 NO ordens-embarque} /* busca valores atributos livres */

        /*
        ** Verifica se j† foram informados valores para o item nas ordens de embarque
        */

        &IF DEFINED(bf-mat-comex) &THEN
           IF i-trib-ii-i1       <> 0 OR 
              i-trib-ipi-i1      <> 0 OR 
              i-trib-icms-i1     <> 0 OR 
              de-peso-bruto-i1   <> 0 OR 
              de-peso-liquido-i1 <> 0 OR 
              de-aliq-ii-i1      <> 0 OR 
              de-aliq-ipi-i1     <> 0 OR 
              de-aliq-icms-i1    <> 0 THEN
                ASSIGN l-gravado = YES.                        
            ELSE
                ASSIGN l-gravado = NO.
        &ELSE
            &IF '{&bf_mat_versao_ems}' < '2.05' &THEN
                IF i-trib-ii-i1       <> 0 OR 
                   i-trib-ipi-i1      <> 0 OR 
                   i-trib-icms-i1     <> 0 OR
                   de-peso-bruto-i1   <> 0 OR 
                   de-peso-liquido-i1 <> 0 OR
                   de-aliq-ii-i1      <> 0 OR
                   de-aliq-ipi-i1     <> 0 OR
                   de-aliq-icms-i1    <> 0 THEN
                    ASSIGN l-gravado = YES.                        
                ELSE
                    ASSIGN l-gravado = NO.
            &ELSE
                {cxbo/bocx225e.i4 NO ordens-embarque} /* busca valores atributos livres */
                ASSIGN l-gravado = l-ja-gravado.
            &ENDIF
        &ENDIF
    END.
    
    IF l-gravado THEN DO:
         
        FOR EACH ordens-embarque
            WHERE ordens-embarque.cod-estabel = RowObject.cod-estabel
              AND ordens-embarque.embarque    = RowObject.embarque    NO-LOCK:

            {cxbo/bocx225e.i2 NO ordens-embarque} /* busca valores atributos livres */

            {imp/im0045ab.i50} /* Include tratamento atributo livre ordens-embarque.char-1 */            
            /*
            ** Drawback - 2.03 - tratamento n£mero ato concess¢rio
            */
            &if defined (bf_mat_versao_ems) &then
               &if "{&bf_mat_versao_ems}" >= "2.03" &then
                   {cdp/cd4300.i4 "yes" ordens-embarque.char-1} 
                   {imp/im0045ab.i51 "yes"}
               &endif
            &endif
            
            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
            IF AVAIL ordem-compra THEN DO:
                IF ordem-compra.dep-almoxar <> "" then
                   ASSIGN c-cod-depos = ordem-compra.dep-almoxar.
                ELSE
                   &IF DEFINED(bf-mat-comex) &THEN
                   &ELSE
                       ASSIGN c-cod-depos = c-deposito-pad.
                   &ENDIF
                       
                FIND cotacao-item 
                  WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                    AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
                    AND cotacao-item.it-codigo    = ordem-compra.it-codigo    
                    AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
    
                IF AVAIL cotacao-item THEN DO:
    
                    &IF DEFINED(bf-mat-comex) &THEN
                    &ELSE
                      {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                      {ccp/cc9019.i51 "yes"}
                    &ENDIF
                    FIND ITEM WHERE
                         ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL ITEM THEN
                        ASSIGN c-class-fiscal = ITEM.class-fiscal.
                    &IF DEFINED(bf-mat-comex) &THEN
                    &ELSE
                       IF ITEM.tipo-contr = 4 THEN DO:
                           IF AVAIL cotacao-item THEN DO:
                               IF c-class-fiscal-i50 <> "" THEN
                                   ASSIGN c-class-fiscal = TRIM(c-class-fiscal-i50).
                           END.
                       END.
                    &ENDIF
                    ASSIGN de-preco-unit-mo = (cotacao-item.pre-unit-for * 100)
                                           / (100 + cotacao-item.aliquota-ipi).
                    ASSIGN de-preco-total-mo = de-preco-unit-mo 
                                          * ordens-embarque.qt-do-forn
                           de-preco-total    = de-preco-total-mo.
                END.
            END.
            IF NOT CAN-FIND(FIRST tt-bo-erro)  AND
               NOT l-create-itens THEN DO:
                   CREATE tt-itens.
                   ASSIGN tt-itens.numero-ordem       = ordens-embarque.numero-ordem
                          tt-itens.parcela            = ordens-embarque.parcela
                          tt-itens.nr-proc-imp        = ordens-embarque.nr-proc-imp                           
                          tt-itens.quantidade         = ordens-embarque.quantidade
                          tt-itens.encerra-pa         = NO
                          tt-itens.it-codigo          = ITEM.it-codigo
                      &IF '{&ems_dbtype}' <> 'progress' &THEN
                         tt-itens.class-fiscal   = SUBSTRING(c-class-fiscal,1,8)
                      &ELSE
                         tt-itens.class-fiscal   = SUBSTRING(c-class-fiscal,1,8)
                      &ENDIF
                          tt-itens.nr-ato-concessorio = c-nr-ato-concessorio
                          tt-itens.preco-total        = de-preco-total
                          tt-itens.preco-total-mo     = de-preco-total-mo
                          tt-itens.num-pedido         = ordem-compra.num-pedido
                          tt-itens.tp-despesa         = ordem-compra.tp-despesa
                          tt-itens.cod-depos          = c-cod-depos
                          tt-itens.l-regime           = l-regime
                          tt-itens.aliquota-ipi       = de-aliquota-ipi
                          tt-itens.l-ordens-embarque  = YES.
                          &if '{&bf_mat_versao_ems}' >= '2.05' &then
                              &if "{&bf_mat_versao_ems}" >= "2.062" &then
                                 ASSIGN tt-itens.val-cub-tot  = ordens-embarque.val-cub-tot.
                             &else
                                 ASSIGN tt-itens.val-cub-uni  = ordens-embarque.val-cub-uni.
                             &endif          
                         &ENDIF
    
                          
                        ASSIGN tt-itens.peso-bruto   = de-peso-bruto-i1   
                               tt-itens.peso-liquido = de-peso-liquido-i1.
            END.
        END.
        RUN setTTitens IN h-im0091 (INPUT TABLE tt-itens).
        FIND FIRST natur-oper NO-LOCK NO-ERROR.
            RUN rateioEmbarque IN h-im0091 (INPUT RowObject.cod-estabel,
                                            INPUT RowObject.embarque,
                                            INPUT natur-oper.nat-operacao,
                                            OUTPUT TABLE tt-desp-rateio).
            RUN getTTbo-erro       IN h-im0091 (OUTPUT TABLE tt-bo-erro).
            DELETE PROCEDURE h-im0091.
            IF CAN-FIND(FIRST tt-bo-erro) THEN
                UNDO, LEAVE.

    END.
    ELSE
        IF NOT l-gravado THEN DO:
            FIND FIRST natur-oper NO-LOCK NO-ERROR.
            RUN rateioEmbarque IN h-im0091 (INPUT RowObject.cod-estabel,
                                            INPUT RowObject.embarque,
                                            INPUT natur-oper.nat-operacao,
                                            OUTPUT TABLE tt-desp-rateio).
                                              
            RUN getTTbo-erro       IN h-im0091 (OUTPUT TABLE tt-bo-erro).
            DELETE PROCEDURE h-im0091.
            IF CAN-FIND(FIRST tt-bo-erro) THEN
                UNDO,LEAVE.

        END.

    RETURN "OK":U.

END PROCEDURE.



PROCEDURE atualizaFormaPrecoCompra:
    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE INPUT  PARAMETER TABLE FOR tt-desp-rateio.
    DEFINE INPUT  PARAMETER pc-Acao AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.


    DEFINE VARIABLE l-preco-bruto   AS   LOGICAL INITIAL NO        NO-UNDO.
    DEFINE VARIABLE deIndice        AS   DECIMAL                   NO-UNDO.
    DEFINE VARIABLE c-desc-despesa  AS   CHARACTER                 NO-UNDO.
    DEFINE VARIABLE de-pre-unit-for LIKE ordem-compra.pre-unit-for NO-UNDO.

    FIND FIRST RowObject NO-LOCK NO-ERROR.

    IF pc-Acao = "ADD":U THEN DO:

        FOR EACH tt-desp-rateio
            WHERE tt-desp-rateio.cod-desp = RowObject.cod-desp:
            FIND ordens-embarque
                WHERE ordens-embarque.cod-estabel  = RowObject.cod-estabel
                  AND ordens-embarque.embarque     = RowObject.embarque  
                  AND ordens-embarque.numero-ordem = tt-desp-rateio.numero-ordem
                  AND ordens-embarque.parcela      = tt-desp-rateio.parcela NO-LOCK NO-ERROR.

            FIND ordem-compra
                WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN
                FIND cotacao-item 
                  WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                    AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
                    AND cotacao-item.it-codigo    = ordem-compra.it-codigo    
                    AND cotacao-item.cot-aprovada EXCLUSIVE-LOCK NO-ERROR.


            FOR FIRST item-fornec FIELDS(fator-conver num-casa-dec)
                WHERE item-fornec.it-codigo    = ordem-compra.it-codigo
                  AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
            END.

            IF AVAIL ordem-compra THEN DO:
                IF tt-desp-rateio.val-desp-unit-mo >= ordem-compra.preco-fornec THEN DO:
                    ASSIGN i-seq-erro = i-seq-erro + 1.
                    RUN utp/ut-msgs.p (INPUT "msg",
                                       INPUT 31452,
                                       INPUT ordem-compra.numero-ordem).
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 31452
                           tt-bo-erro.mensagem = TRIM(RETURN-VALUE).
                END.
                ELSE DO:

                    IF AVAIL ordem-compra THEN
                        ASSIGN de-pre-unit-for  = ordem-compra.pre-unit-for.
                    
                    IF AVAIL cotacao-item THEN DO:
                        FIND FIRST desp-imp
                             WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp NO-LOCK NO-ERROR.
                        IF AVAIL desp-imp THEN
                            /*
                            ** Despesa do tipo valor fixo
                            */               
                            IF desp-imp.tipo = 1 THEN
                                ASSIGN tt-desp-rateio.val-desp-unit    = tt-desp-rateio.val-desp-unit    / ordens-embarque.qt-do-forn
                                       tt-desp-rateio.val-desp-unit-mo = tt-desp-rateio.val-desp-unit-mo / ordens-embarque.qt-do-forn.

                        ASSIGN ordem-compra.preco-fornec = ordem-compra.preco-fornec - 
                                                           tt-desp-rateio.val-desp-unit-mo.
                        ASSIGN cotacao-item.preco-fornec = cotacao-item.preco-fornec - 
                                                           tt-desp-rateio.val-desp-unit-mo.

                        {cdp/cd9300.i ordem-compra}
                        {cdp/cd9300.i cotacao-item}

                        IF AVAIL item-fornec THEN
                            ASSIGN deIndice = ( item-fornec.fator-conver / (IF item-fornec.num-casa-dec = 0 THEN 1
                                                                            ELSE EXP(10, item-fornec.num-casa-dec)) ).
                        ELSE
                            ASSIGN deIndice = 1.

                        ASSIGN ordem-compra.preco-unit = ordem-compra.pre-unit-for * deIndice
                               cotacao-item.preco-unit = cotacao-item.pre-unit-for * deIndice.

                        IF AVAIL ordens-embarque THEN
                        FIND FIRST prazo-compra  
                             WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                               AND prazo-compra.parcela      = ordens-embarque.parcela NO-LOCK NO-ERROR.
                        IF AVAIL prazo-compra THEN DO:

                            FIND FIRST pedido-compr 
                                 WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
                            &IF DEFINED(bf-mat-comex) &THEN
                                 IF AVAIL pedido-compr 
                                      AND pedido-compr.situacao = "I"
                            &ELSE
                                   IF AVAIL pedido-compr 
                                        AND pedido-compr.situacao = 1
                            &ENDIF
                               THEN DO:
                                FIND emitente 
                                    WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

                                FIND desp-imp
                                    WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp NO-LOCK NO-ERROR.
                                IF AVAIL desp-imp THEN
                                    ASSIGN c-desc-despesa = desp-imp.descricao.

                                FIND alt-ped 
                                    WHERE alt-ped.num-pedido   = ordem-compra.num-pedido
                                      AND alt-ped.numero-ordem = ordem-compra.numero-ordem
                                      AND alt-ped.parcela      = prazo-compra.parcela
                                      AND alt-ped.data         = TODAY
                                      AND alt-ped.hora         = STRING(TIME,"HH:MM:SS") EXCLUSIVE-LOCK NO-ERROR.

                                IF NOT AVAIL alt-ped THEN DO:
                                    CREATE alt-ped.
                                    ASSIGN alt-ped.data         = TODAY
                                           alt-ped.hora         = STRING(TIME,"HH:MM:SS")
                                           alt-ped.num-pedido   = ordem-compra.num-pedido
                                           alt-ped.numero-ordem = ordem-compra.numero-ordem
                                           alt-ped.parcela      = prazo-compra.parcela.
                                END.
                                ASSIGN alt-ped.usuario      = c-seg-usuario
                                       alt-ped.observacao   = "Valor da despesa de Importaá∆o " + STRING(tt-desp-rateio.cod-desp) + " - " + c-desc-despesa + " Inclu°da ao valor do Material"
                                       alt-ped.data-entrega = ?
                                       alt-ped.quantidade   = ordens-embarque.quantidade
                                       alt-ped.cod-cond-pag = ?.
        
                                &if defined(bf-mat-comex) &then
                                &else
                                    assign alt-ped.char-1 = "0".
                                    if  de-pre-unit-for <> ordem-compra.pre-unit-for then
                                        assign alt-ped.preco = de-pre-unit-for.

                                    /* Grava dados atuais */
                                    if  de-pre-unit-for <> ordem-compra.pre-unit-for THEN
                                        assign alt-ped.char-1 = string(ordem-compra.pre-unit-for).
                                    else
                                        assign alt-ped.char-1 = "0".
                                &endif
                                assign alt-ped.char-1       = alt-ped.char-1 + "|" + string(prazo-compra.qtd-sal-forn).
                                ASSIGN alt-ped.char-1       = alt-ped.char-1 + "|" + "?".
        
                                IF AVAIL emitente THEN
                                    ASSIGN alt-ped.nome-abrev   = emitente.nome-abrev.
                            END.
                        END.
                        /**************** criacao da alt-ped boin356aa.p ************************/
                    END.
                END.
            END.
        END.
    END. /*pc-Acao = ADD*/

    IF pc-Acao = "DEL":U THEN DO:
        IF AVAIL {&table-name} THEN
        FOR EACH tt-desp-rateio
            WHERE tt-desp-rateio.cod-desp = {&table-name}.cod-desp:

            FIND ordens-embarque
                WHERE ordens-embarque.cod-estabel  = RowObject.cod-estabel
                  AND ordens-embarque.embarque     = RowObject.embarque  
                  AND ordens-embarque.numero-ordem = tt-desp-rateio.numero-ordem
                  AND ordens-embarque.parcela      = tt-desp-rateio.parcela NO-LOCK NO-ERROR.

            FIND ordem-compra
                WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN
                FIND cotacao-item 
                  WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                    AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
                    AND cotacao-item.it-codigo    = ordem-compra.it-codigo    
                    AND cotacao-item.cot-aprovada EXCLUSIVE-LOCK NO-ERROR.


            FOR FIRST item-fornec FIELDS(fator-conver num-casa-dec)
                WHERE item-fornec.it-codigo    = ordem-compra.it-codigo
                  AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
            END.

            IF AVAIL ordem-compra THEN
                ASSIGN de-pre-unit-for  = ordem-compra.pre-unit-for.

            FIND FIRST desp-imp
                 WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp NO-LOCK NO-ERROR.

            IF AVAIL desp-imp THEN
                /*
                ** Despesa do tipo valor fixo
                */               
                IF desp-imp.tipo = 1 THEN
                    ASSIGN tt-desp-rateio.val-desp-unit    = tt-desp-rateio.val-desp-unit    / ordens-embarque.qt-do-forn
                           tt-desp-rateio.val-desp-unit-mo = tt-desp-rateio.val-desp-unit-mo / ordens-embarque.qt-do-forn.

            ASSIGN ordem-compra.preco-fornec = ordem-compra.preco-fornec +
                                               tt-desp-rateio.val-desp-unit-mo.
    
            ASSIGN cotacao-item.preco-fornec = cotacao-item.preco-fornec + 
                                               tt-desp-rateio.val-desp-unit-mo.
            
            {cdp/cd9300.i ordem-compra}
            {cdp/cd9300.i cotacao-item}
            
            IF AVAIL item-fornec THEN
                ASSIGN deIndice = ( item-fornec.fator-conver / (IF item-fornec.num-casa-dec = 0 THEN 1
                                                                ELSE EXP(10, item-fornec.num-casa-dec)) ).
    
            ELSE
                ASSIGN deIndice = 1.
    
            ASSIGN ordem-compra.preco-unit = ordem-compra.pre-unit-for * deIndice
                   cotacao-item.preco-unit = cotacao-item.pre-unit-for * deIndice.

            IF AVAIL ordens-embarque THEN
            FIND FIRST prazo-compra  
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                   AND prazo-compra.parcela      = ordens-embarque.parcela NO-LOCK NO-ERROR.
            IF AVAIL prazo-compra THEN DO:
    
                FIND FIRST pedido-compr 
                     WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
                &IF DEFINED(bf-mat-comex) &THEN
                     IF AVAIL pedido-compr 
                          AND pedido-compr.situacao = "I"
                &ELSE
                       IF AVAIL pedido-compr 
                            AND pedido-compr.situacao = 1
                &ENDIF
                   THEN DO:
    
                    FIND emitente 
                        WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
    
                    FIND desp-imp
                        WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp NO-LOCK NO-ERROR.
                    IF AVAIL desp-imp THEN
                        ASSIGN c-desc-despesa = desp-imp.descricao.
    
                    FIND alt-ped 
                        WHERE alt-ped.num-pedido   = ordem-compra.num-pedido
                          AND alt-ped.numero-ordem = ordem-compra.numero-ordem
                          AND alt-ped.parcela      = prazo-compra.parcela
                          AND alt-ped.data         = TODAY
                          AND alt-ped.hora         = STRING(TIME,"HH:MM:SS") EXCLUSIVE-LOCK NO-ERROR.

                    IF NOT AVAIL alt-ped THEN DO:
                        CREATE alt-ped.
                        ASSIGN alt-ped.data         = TODAY
                               alt-ped.hora         = STRING(TIME,"HH:MM:SS")
                               alt-ped.num-pedido   = ordem-compra.num-pedido
                               alt-ped.numero-ordem = ordem-compra.numero-ordem
                               alt-ped.parcela      = prazo-compra.parcela.
                    END.

                    ASSIGN alt-ped.usuario      = c-seg-usuario
                           alt-ped.observacao   = "Valor da despesa de Importaá∆o " + STRING(tt-desp-rateio.cod-desp) + " - " + c-desc-despesa + " Eliminada do valor do Material"
                           alt-ped.data-entrega = ?
                           alt-ped.quantidade   = ordens-embarque.quantidade
                           alt-ped.cod-cond-pag = ?.
    
                   &if defined(bf-mat-comex) &then
                   &else
                       assign alt-ped.char-1 = "0".
                       if  de-pre-unit-for <> ordem-compra.pre-unit-for /* ordem-compra.pre-unit-for */ then
                           assign alt-ped.preco = de-pre-unit-for.

                       /* Grava dados atuais */
                       if  de-pre-unit-for <> ordem-compra.pre-unit-for THEN
                           assign alt-ped.char-1 = string(ordem-compra.pre-unit-for).
                       else
                           assign alt-ped.char-1 = "0".
                   &endif
                   assign alt-ped.char-1       = alt-ped.char-1 + "|" + string(prazo-compra.qtd-sal-forn).
                   ASSIGN alt-ped.char-1       = alt-ped.char-1 + "|" + "?".

                    IF AVAIL emitente THEN
                        ASSIGN alt-ped.nome-abrev   = emitente.nome-abrev.
             
                   IF AVAIL emitente THEN
                       ASSIGN alt-ped.nome-abrev   = emitente.nome-abrev.
                END.
            END.
        END.
    END.


    RETURN "OK":U.
END PROCEDURE.

PROCEDURE VerificaFormaPrecoCompra:
    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE OUTPUT PARAMETER pl-forma-preco-compra AS LOGICAL NO-UNDO.

    FIND FIRST RowObject NO-ERROR.
    FIND FIRST desp-embarque 
         WHERE desp-embarque.cod-estabel  = RowObject.cod-estabel 
           AND desp-embarque.embarque     = RowObject.embarque    
           AND desp-embarque.cod-itiner   = RowObject.cod-itiner  
           AND desp-embarque.cod-desp     = RowObject.cod-desp NO-LOCK NO-ERROR.

    IF AVAIL desp-embarque THEN DO:
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
           IF desp-embarque.log-forma-preco-compra THEN
       &ELSE
           IF SUBSTRING(desp-embarque.char-1,4,1) = "1" THEN  /* forma preco compra */
       &ENDIF
               ASSIGN pl-forma-preco-compra = YES.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE atzDespesaEmbarque:
    DEF INPUT PARAM p-cod-estab        AS CHAR     NO-UNDO.
    DEF INPUT PARAM p-embarque         AS CHAR     NO-UNDO.
    DEF INPUT PARAM p-de-tx-siscomex   AS DEC      NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    
    DEF VAR i-cod-desp  LIKE desp-embarque.cod-desp NO-UNDO.
    DEF VAR i-fornec    LIKE desp-embarque.cod-emitente-desp NO-UNDO.
    DEF VAR r-desp-emb    AS ROWID NO-UNDO.
    
    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = p-cod-estab NO-ERROR.
    
    &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
        ASSIGN i-cod-desp = param-imp.cdn-despes-siscomex
               i-fornec   = param-imp.cdn-emit-siscomex.
    &ELSE
        ASSIGN i-cod-desp = INT(SUBSTR(param-imp.char-1,91,5))
               i-fornec   = INT(SUBSTR(param-imp.char-1,96,9)).
    &ENDIF
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = i-fornec NO-ERROR.
    FIND FIRST historico-embarque NO-LOCK
         WHERE historico-embarque.cod-estabel = p-cod-estab
           AND historico-embarque.embarque    = p-embarque NO-ERROR.

    FOR FIRST embarque-imp FIELDS(cdn-pto-desembar) NO-LOCK 
        WHERE embarque-imp.cod-estabel =  p-cod-estab
          AND embarque-imp.embarque    = p-embarque: END.
    
    FIND FIRST desp-embarque NO-LOCK
         WHERE desp-embarque.cod-estabel       = p-cod-estab
           AND desp-embarque.embarque          = p-embarque
           AND desp-embarque.cod-itiner        = historico-embarque.cod-itiner
           AND desp-embarque.cod-pto-contr     = embarque-imp.cdn-pto-desembar
           AND desp-embarque.cod-desp          = i-cod-desp
           AND desp-embarque.cod-emitente-desp = i-fornec NO-ERROR.
    IF  AVAIL desp-embarque THEN DO:
        ASSIGN r-desp-emb = ROWID(desp-embarque).
        
        IF  p-de-tx-siscomex = 0 THEN DO:
            RUN validateDelete IN THIS-PROCEDURE (INPUT-OUTPUT r-desp-emb,
                                                  OUTPUT TABLE tt-bo-erro).
        END.
        ELSE DO:
            CREATE tt-desp-embarque.
            BUFFER-COPY desp-embarque TO tt-desp-embarque.
            ASSIGN tt-desp-embarque.val-desp = p-de-tx-siscomex.
            
            RUN validateUpdate IN THIS-PROCEDURE (INPUT  TABLE tt-desp-embarque,
                                                  INPUT  r-desp-emb,
                                                  OUTPUT TABLE tt-bo-erro).
        END.
    END.
    ELSE DO:
        IF  p-de-tx-siscomex <> 0 THEN DO:
            FIND FIRST desp-embarque NO-LOCK
                 WHERE desp-embarque.cod-estabel  = p-cod-estab
                   AND desp-embarque.embarque     = p-embarque
                   AND desp-embarque.cod-itiner   = historico-embarque.cod-itiner
                   AND desp-embarque.cod-desp     = i-cod-desp NO-ERROR.
            IF  AVAIL desp-embarque THEN DO:
                ASSIGN i-seq-erro = i-seq-erro + 1.
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 33867,
                                   INPUT "").
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 33867
                       tt-bo-erro.mensagem     = return-value.
            END.
            ELSE DO:
                CREATE tt-desp-embarque.
                ASSIGN tt-desp-embarque.cod-estabel       = p-cod-estab
                       tt-desp-embarque.embarque          = p-embarque
                       tt-desp-embarque.cod-itiner        = historico-embarque.cod-itiner
                       tt-desp-embarque.cod-pto-contr     = embarque-imp.cdn-pto-desembar
                       tt-desp-embarque.cod-desp          = i-cod-desp
                       tt-desp-embarque.cod-emitente-desp = i-fornec
                       tt-desp-embarque.cod-cond-pag      = emitente.cod-cond-pag
                       tt-desp-embarque.mo-codigo         = 0
                       tt-desp-embarque.val-desp          = p-de-tx-siscomex.

                FIND FIRST desp-imp
                     WHERE desp-imp.cod-desp = i-cod-desp NO-LOCK NO-ERROR.
                IF AVAIL desp-imp THEN
                     ASSIGN tt-desp-embarque.descricao = desp-imp.descricao.
                
                RUN validateCreate IN THIS-PROCEDURE (INPUT  TABLE tt-desp-embarque,
                                                      OUTPUT TABLE tt-bo-erro,
                                                      OUTPUT r-desp-emb).
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-grava-siscoserv:
    /*
        Procedure para a criaá∆o da tabela de extens∆o do Siscoserv
    */

    /*** Siscoserv ***/
    IF CAN-FIND (FIRST emitente no-lock
                    WHERE emitente.cod-emitente = rowObject.cod-emitente-desp
                    AND   UPPER(emitente.pais) <> "BRASIL":U) THEN DO:
        IF NOT VALID-HANDLE(h-cdapi050) THEN
            RUN cdp/cdapi050 PERSISTENT SET h-cdapi050.
        RUN pi-siscoserv-ativo IN h-cdapi050.
        IF RETURN-VALUE = "OK":U THEN DO:
            FOR FIRST historico-embarque FIELDS(dt-previsao)                         
                WHERE historico-embarque.cod-estabel   = rowObject.cod-estabel
                AND   historico-embarque.embarque      = rowObject.embarque  
                AND   historico-embarque.cod-itiner    = rowObject.cod-itiner   
                AND   historico-embarque.cod-pto-contr = rowObject.cod-pto-contr NO-LOCK:

                RUN pi-grava-despes-import-sis IN h-cdapi050 (INPUT rowObject.cod-estabel,
                                                              INPUT rowObject.embarque,
                                                              INPUT rowObject.cod-itiner,
                                                              INPUT rowObject.cod-pto-contr,
                                                              INPUT rowObject.cod-desp,
                                                              INPUT rowObject.cod-emitente-desp,
                                                              INPUT historico-embarque.dt-previsao).
            END.
        END. /*FOR FIRST historico-embarque*/
    END. /*CAN-FIND emitente*/
    
    IF VALID-HANDLE(h-cdapi050) THEN DO:
        DELETE PROCEDURE h-cdapi050.
        ASSIGN h-cdapi050 = ?.
    END.
        
    /*** Siscoserv ***/
END.

procedure pi-valida-despesa-acomp:
/*-----------------------------------------------------------------------------------
    Purpose: Validaá∆o da despesa do ponto do itinerario. (verificaá∆o de duplicata e outras)
    Parameters: input - RowObject (temp-table) : Informaá‰es da despesa 
                output - tt-bo-erro (temp-table) : Erros ocorridos durante o processo.
    Notes:   
-----------------------------------------------------------------------------------*/
    def input  parameter table for RowObject.
    def input  parameter p-cod-desp-ant like desp-imp.cod-desp no-undo.
    def output parameter table for tt-bo-erro.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    find first RowObject no-error.
    
    find first desp-embarque 
         where desp-embarque.cod-estabel  = rowObject.cod-estabel 
           and desp-embarque.embarque     = rowObject.embarque    
           and desp-embarque.cod-itiner   = rowObject.cod-itiner  
           and desp-embarque.cod-desp     = rowObject.cod-desp
           and rowid(desp-embarque)      <> rowObject.r-rowid no-lock no-error.
    if avail desp-embarque then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-table.i mgcex desp-embarque 1}
        run utp/ut-msgs.p (input "msg",
                           input 8,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 8
               tt-bo-erro.mensagem     = return-value.
    end.

    /* Verifica se o novo ponto est† faturado (se estiver faturado) */
    IF CAN-FIND(FIRST historico-embarque 
                WHERE historico-embarque.cod-estabel   = RowObject.cod-estabel
                  AND historico-embarque.embarque      = RowObject.embarque
                  AND historico-embarque.cod-itiner    = RowObject.cod-itiner
                  AND historico-embarque.cod-pto-contr = RowObject.cod-pto-contr
                  AND historico-embarque.dt-efetiva   <> ?) THEN DO: 
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i "O ponto de controle "}
        run utp/ut-msgs.p (input "msg",
                           input 26202,
                           input RETURN-VALUE + STRING(RowObject.cod-pto-contr)).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 26202
               tt-bo-erro.mensagem     = return-value
               tt-bo-erro.errorhelp    = return-value.
    END.

    IF i-pais-impto-usuario <> 1 
        AND NOT l-update-rateio-im3101d THEN DO:

        IF p-cod-desp-ant <> 0 
            AND p-cod-desp-ant <> RowObject.cod-desp THEN DO:

            IF CAN-FIND(FIRST bf-desp-embarque
                        WHERE bf-desp-embarque.cod-estabel       =  RowObject.cod-estabel
                          AND bf-desp-embarque.embarque          =  RowObject.embarque
                          AND bf-desp-embarque.cod-itiner        =  RowObject.cod-itiner 
                          AND bf-desp-embarque.cod-pto-contr     =  RowObject.cod-pto-contr
                          AND bf-desp-embarque.cod-desp          <> RowObject.cod-desp
                          AND bf-desp-embarque.cod-emitente-desp =  RowObject.cod-emitente-desp
                          AND bf-desp-embarque.log-prorate-efetd) THEN DO:
    
                        RUN utp/ut-msgs.p (INPUT "msg",
                                           INPUT 55680,
                                           INPUT "").
                        CREATE tt-bo-erro.
                        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                               tt-bo-erro.cd-erro  = 55680
                               tt-bo-erro.mensagem = TRIM(RETURN-VALUE).
            END.
        END.

        IF CAN-FIND(FIRST bf-desp-embarque
                    WHERE bf-desp-embarque.cod-estabel       = RowObject.cod-estabel
                      AND bf-desp-embarque.embarque          = RowObject.embarque
                      AND bf-desp-embarque.cod-itiner        = RowObject.cod-itiner 
                      AND bf-desp-embarque.cod-pto-contr     <> RowObject.cod-pto-contr
                      AND bf-desp-embarque.cod-desp          = RowObject.cod-desp
                      AND bf-desp-embarque.cod-emitente-desp = RowObject.cod-emitente-desp
                      AND bf-desp-embarque.log-prorate-efetd) THEN DO:

            FOR FIRST historico-embarque 
                WHERE historico-embarque.cod-estabel   = RowObject.cod-estabel
                  AND historico-embarque.embarque      = RowObject.embarque
                  AND historico-embarque.cod-itiner    = RowObject.cod-itiner
                  AND historico-embarque.cod-pto-contr = RowObject.cod-pto-contr:                   
                ASSIGN i-seq-novo-ponto = historico-embarque.sequencia.       
            END.  

            FOR FIRST embarque-imp NO-LOCK
                WHERE embarque-imp.cod-estabel = RowObject.cod-estabel   
                AND   embarque-imp.embarque    = RowObject.embarque :
                ASSIGN i-cdn-pto-nacionaliz = embarque-imp.cdn-pto-desembar
                       i-cdn-pto-chegada    = embarque-imp.cdn-pto-chegad.

                FOR FIRST historico-embarque 
                    WHERE historico-embarque.cod-estabel   = RowObject.cod-estabel
                      AND historico-embarque.embarque      = RowObject.embarque
                      AND historico-embarque.cod-itiner    = RowObject.cod-itiner
                      AND historico-embarque.cod-pto-contr = i-cdn-pto-nacionaliz:                   
                    ASSIGN i-seq-nacionaliz = historico-embarque.sequencia.       
                END.                                                              
            END.

            IF RowObject.cod-pto-contr = i-cdn-pto-nacionaliz
                OR RowObject.cod-pto-contr = i-cdn-pto-chegada THEN DO:

                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 55681,
                                   INPUT "").
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 55681
                       tt-bo-erro.mensagem = TRIM(RETURN-VALUE).
            END.

            IF i-seq-novo-ponto < i-seq-nacionaliz THEN DO:

                    RUN utp/ut-msgs.p (INPUT "msg",
                                       INPUT 55682,
                                       INPUT "").
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 55682
                           tt-bo-erro.mensagem = TRIM(RETURN-VALUE).
            END.
        END.
    END.
    
    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setaExecutaRateioInternacional:

    ASSIGN l-update-rateio-im3101d = YES.

END PROCEDURE.

PROCEDURE getFieldErrors:
/*------------------------------------------------------------------------------------------
Purpose: Retornar uma temp-table com informaá‰es dos erros ocorridos durante alteraá∆o/criaá∆o.
Parameters:  (output) (temp-table) tt-campo-erro: Nome do campo em que ocorreu o erro.
Notes: 
------------------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER TABLE FOR tt-campo-erro.

   RETURN "OK":U.
END PROCEDURE.
