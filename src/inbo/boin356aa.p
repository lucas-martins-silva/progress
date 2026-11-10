/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN356AA 2.00.00.039 } /*** "010039" 21/06/2024 16:52:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOIN356AA MEN}
&ENDIF




&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 


{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */
/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/*******************************************************************************
**
**  BOIN356AA.P
**
**  PRAZO-COMPRA 
**
*******************************************************************************/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN356a
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName prazo-compra
&GLOBAL-DEFINE TableLabel 

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-prazo-compra
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-prazo-compra


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin356aa.i RowObject}
{inbo/boin356aa.i tt-prazo-compra}
{inbo/boin356aa.i tt-prazo-compra-aux}
{cxbo/bocx351.i tt-licenciam-import-oc}
{cxbo/bocx351.i tt-licenciam-import-oc-aux}

{method/dbotterr.i}
{include/boini.i}
{utp/ut-glob.i}

{include/i-epc200.i "boin356aa"}


{cdp/cd4300.i3} /* Atributos livres */
{ccp/cc9019.i50} /* Atributos livres cotacao-item.char-1 */

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bfprazo-compra FOR prazo-compra.

DEFINE TEMP-TABLE tt-ordem-compra no-undo like ordem-compra
                  field d-data  as date format "99/99/9999"
                  field r-rowid   as rowid
    INDEX ch-ordem IS PRIMARY UNIQUE
          numero-ordem.

DEFINE VARIABLE i-numero-ordem LIKE ordem-compra.numero-ordem   NO-UNDO.
DEFINE VARIABLE i-num-pedido   LIKE pedido-compr.num-pedido     NO-UNDO.
DEFINE VARIABLE r-embarque     AS   ROWID                       NO-UNDO.
DEFINE VARIABLE deIndice       AS   DECIMAL                     NO-UNDO.
DEFINE VARIABLE c-nr-parcela   AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE l-acompan      AS   LOGICAL                     NO-UNDO.
DEFINE VARIABLE h-bocx150      AS   HANDLE                      NO-UNDO.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 1.96
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

/*{method/dbo.i}*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


{method/svc/autentic/autentic.i 
            &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClearParcelaCriada DBOProgram 
PROCEDURE ClearParcelaCriada :
ASSIGN c-nr-parcela = "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-nova-parcela DBOProgram 
PROCEDURE cria-nova-parcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter p-cod-estabel        like ordem-compra.cod-estabel  no-undo.
    define input parameter p-numero-ordem       like ordem-compra.numero-ordem no-undo.
    define input parameter p-parcela            like prazo-compra.parcela      no-undo.
    define input parameter p-embarque           like embarque-imp.embarque     no-undo.
    define input parameter p-nova-quantidade    like prazo-compra.quantidade   no-undo.
    define input parameter p-quantidade         like prazo-compra.quantidade   no-undo.
    define input parameter p-nova-entrega       like prazo-compra.data-entrega no-undo.
    define input parameter p-ordemparcela       as   char                      no-undo.
    define buffer          b-prazo-compra       for  prazo-compra.
    DEFINE BUFFER b-eq-embarq-praz-compra       FOR eq-embarq-praz-compra. 
    DEFINE BUFFER b-eq-embarq-praz-compra-aux   FOR eq-embarq-praz-compra. 
    DEFINE BUFFER b-prazo-compra-aux            FOR prazo-compra.
    
    define variable        v-qtde-ordem         like prazo-compra.quantidade   no-undo.
    define variable        i-num-parc           as integer                     no-undo.
    define variable        i-cont               as integer                     no-undo.
    define variable        v-quantidade         as integer                     no-undo.
    define variable        da-data-entrega      as date                        no-undo.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.

    &if defined(bf_mat_importacao_mrp) &then
        if not valid-handle (h-bocx150) then
            if connected("mgcex") then
                run cxbo/bocx150.p persistent set h-bocx150.
    &endif

    if p-ordemparcela = "ordem" THEN do:
        find first ordem-compra no-lock
             where ordem-compra.cod-estabel  = p-cod-estabel
               and ordem-compra.numero-ordem = p-numero-ordem no-error.
        if not avail ordem-compra then leave.
        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        ASSIGN i-num-parc = 0.
        
        for each  prazo-compra NO-LOCK 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
            assign i-num-parc = i-num-parc + 1.
        end.
    
        assign i-cont   = 1.
        
        do i-cont = 1 to i-num-parc:                                                   
           find first ordens-embarque no-lock
                where ordens-embarque.cod-estabel   = p-cod-estabel
                and   ordens-embarque.embarque      = p-embarque
                and   ordens-embarque.numero-ordem  = p-numero-ordem
                and   ordens-embarque.parcela       = i-cont no-error.
           if not avail ordens-embarque THEN do:
              run pi-altera-prazo-compra in this-procedure (input p-numero-ordem ,
                                                            input i-cont         ,
                                                            input p-nova-quantidade).
              leave.                                               
           end.
        end.
    end.    
    else do:
        
        find first ordem-compra no-lock
             where ordem-compra.cod-estabel  = p-cod-estabel
               and ordem-compra.numero-ordem = p-numero-ordem no-error.
        if not avail ordem-compra then leave.
        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        
        assign i-cont   = 0.
        
        find first prazo-compra no-lock
             where prazo-compra.numero-ordem  = p-numero-ordem
             and   prazo-compra.parcela       = p-parcela no-error.
        
        if not avail prazo-compra then leave.
        
        find first ordens-embarque no-lock
             where ordens-embarque.cod-estabel   = p-cod-estabel
             and   ordens-embarque.numero-ordem  = p-numero-ordem
             and   ordens-embarque.parcela       = p-parcela no-error.
        if not avail ordens-embarque or 
           prazo-compra.quantidade > ordens-embarque.quantidade then
        do:
           find last b-prazo-compra 
                where b-prazo-compra.numero-ordem = p-numero-ordem EXCLUSIVE-LOCK no-error.
           if avail b-prazo-compra then                
               assign i-cont = b-prazo-compra.parcela + 1.
           
           assign v-qtde-ordem = 0.
          
           for each ordens-embarque no-lock
               where ordens-embarque.cod-estabel   = p-cod-estabel
               and   ordens-embarque.numero-ordem  = p-numero-ordem
               and   ordens-embarque.parcela       = p-parcela :
               
               if  ordens-embarque.embarque        = p-embarque 
               AND ordens-embarque.quantidade      = prazo-compra.quantidade
               then next.
               else
                assign v-qtde-ordem = v-qtde-ordem + ordens-embarque.quantidade.
           end.   
           
           find first ordens-embarque no-lock
                where ordens-embarque.cod-estabel   = p-cod-estabel
                and   ordens-embarque.numero-ordem  = p-numero-ordem
                and   ordens-embarque.parcela       = p-parcela no-error.

           IF i-pais-impto-usuario <> 1 AND
              AVAIL ordens-embarque AND SUBSTRING(ordens-embarque.char-1,1,20) <> "" /* DIT */ THEN
               assign p-nova-quantidade        = v-qtde-ordem.
           ELSE
               assign p-nova-quantidade = v-qtde-ordem + prazo-compra.qtd-rec-forn - prazo-compra.qtd-rej-forn.

           IF AVAIL ordens-embarque
           AND i-pais-impto-usuario <> 1 THEN
               FOR FIRST embarque-imp NO-LOCK
                   WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                     AND embarque-imp.embarque    = ordens-embarque.embarque: END.

           FIND FIRST prazo-compra EXCLUSIVE-LOCK 
                 WHERE prazo-compra.numero-ordem = p-numero-ordem
                   AND prazo-compra.parcela      = p-parcela NO-ERROR.
           IF AVAIL prazo-compra THEN DO:
               IF prazo-compra.situacao <> 4 THEN DO:
                    ASSIGN deIndice = 1.
                    IF item.tipo-contr <> 4 THEN DO:
                        FIND FIRST item-fornec NO-LOCK
                             WHERE item-fornec.it-codigo    = prazo-compra.it-codigo 
                               AND item-fornec.cod-emitente = ordem-compra.cod-emitente 
                               AND item-fornec.ativo NO-ERROR.
                        IF AVAILABLE item-fornec THEN
                            ASSIGN deIndice = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
                    END.
                    ASSIGN prazo-compra.qtd-do-forn = p-nova-quantidade * deIndice.
               END.

               ASSIGN v-qtde-ordem               = prazo-compra.quantidade
                      prazo-compra.quantidade    = p-nova-quantidade
                      prazo-compra.quant-saldo   = p-nova-quantidade.
               
               IF i-pais-impto-usuario = 1 /* Brasil */ OR
                   (i-pais-impto-usuario <> 1 
                        AND AVAIL ordens-embarque AND SUBSTRING(ordens-embarque.char-1,1,20) = "" /* N∆o Ç embarque DIT */ 
                        AND AVAIL embarque-imp    AND NOT embarque-imp.log-embarq-transf-draw) /*N∆o Ç embarque de transferencia DIT*/ THEN
                   ASSIGN prazo-compra.qtd-sal-forn  = prazo-compra.qtd-do-forn.

               IF prazo-compra.qtd-rec-forn = 0 AND prazo-compra.qtd-rej-forn = 0 THEN
                   ASSIGN prazo-compra.quantid-orig  = p-nova-quantidade.
               
               if  not avail ordem-compra then
                   find ordem-compra EXCLUSIVE-LOCK where 
                        ordem-compra.numero-ordem = prazo-compra.numero-ordem no-error.
                        
               if  avail ordem-compra then do:
                   find first pedido-compr no-lock 
                        where pedido-compr.num-pedido = ordem-compra.num-pedido   
                        no-error.
                   if avail pedido-compr 
                   and pedido-compr.situacao = 1 then do:
                       IF date(substring(prazo-compra.char-2,1,10)) <> ? THEN
                          ASSIGN da-data-entrega = date(substring(prazo-compra.char-2,1,10)).
                       ELSE
                          ASSIGN da-data-entrega = prazo-compra.data-entrega.

                       find emitente where emitente.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
                       create alt-ped.
                       assign alt-ped.data         = today
                              alt-ped.hora         = string(time,"HH:MM:SS")
                              alt-ped.usuario      = c-seg-usuario
                              alt-ped.num-pedido   = ordem-compra.num-pedido
                              alt-ped.numero-ordem = ordem-compra.numero-ordem
                              alt-ped.parcela      = prazo-compra.parcela
                              alt-ped.observacao   = "Inclus∆o Autom†tica de Parcela pelo M¢dulo de Importaá∆o"
                              alt-ped.data-entrega = da-data-entrega
                              alt-ped.quantidade   = v-qtde-ordem
                              alt-ped.cod-cond-pag = ?
                              alt-ped.preco        = ?
                              alt-ped.char-1       = "0" + "|" + string(prazo-compra.qtd-sal-forn).
                       
                       IF  da-data-entrega <> prazo-compra.data-entrega THEN
                           ASSIGN alt-ped.char-1       = alt-ped.char-1 + "|" + string(prazo-compra.data-entrega,"99/99/9999").
                       ELSE
                           ASSIGN alt-ped.char-1       = alt-ped.char-1 + "|" + "".

                       if  avail emitente then       
                           assign alt-ped.nome-abrev   = emitente.nome-abrev.

                       &if defined(bf_mat_compras_edi) &then
                           /* Atualiza dados do pedido e da ordem
                              possibilitando extrair novamente
                              os dados no EDI         */
                           assign ordem-compra.gera-edi = yes.   
                           find pedido-compr where pedido-compr.num-pedido = ordem-compra.num-pedido 
                               exclusive-lock no-error.
                           if  avail pedido-compr then 
                               assign pedido-compr.gera-edi = yes.
                           find current pedido-compr no-lock no-error.
                       &endif
                   end.            
               end.
           end.
        end.

        IF p-quantidade < 0 THEN
           ASSIGN p-quantidade = p-quantidade * (-1).
        if p-quantidade > 0 THEN do:
            
            find first b-prazo-compra 
                 where b-prazo-compra.numero-ordem = p-numero-ordem
                   and b-prazo-compra.parcela      = p-parcela EXCLUSIVE-LOCK no-error.
            
            if avail b-prazo-compra then do:
                create prazo-compra.
                assign prazo-compra.numero-ordem    = b-prazo-compra.numero-ordem
                       prazo-compra.parcela         = i-cont 
                       prazo-compra.data-entrega    = p-nova-entrega
                       prazo-compra.quantidade      = p-quantidade
                       prazo-compra.data-orig       = b-prazo-compra.data-orig
                       prazo-compra.it-codigo       = b-prazo-compra.it-codigo
                       prazo-compra.un              = b-prazo-compra.un   
                       prazo-compra.quantid-orig    = p-quantidade
                       prazo-compra.quant-saldo     = p-quantidade
                       prazo-compra.quant-rejeit    = 0
                       prazo-compra.quant-receb     = 0
                       prazo-compra.qtd-do-forn     = p-quantidade * deIndice 
                       prazo-compra.qtd-sal-forn    = prazo-compra.qtd-do-forn 
                       prazo-compra.qtd-rej-forn    = 0
                       prazo-compra.qtd-rec-forn    = 0
                       prazo-compra.pedido-clien    = b-prazo-compra.pedido-clien
                       prazo-compra.usuario-alt     = ""
                       prazo-compra.data-alter      = ?
                       prazo-compra.nome-abrev      = b-prazo-compra.nome-abrev
                       prazo-compra.nr-alt-data     = b-prazo-compra.nr-alt-data
                       prazo-compra.nr-alt-quant    = b-prazo-compra.nr-alt-quant 
                       prazo-compra.situacao        = b-prazo-compra.situacao
                       prazo-compra.natureza        = b-prazo-compra.natureza
                       prazo-compra.cod-refer       = b-prazo-compra.cod-refer 
                       prazo-compra.concentracao    = b-prazo-compra.concentracao 
                       prazo-compra.rendimento      = b-prazo-compra.rendimento 
                       prazo-compra.nr-sequencia    = b-prazo-compra.nr-sequencia 
                       prazo-compra.cc-codigo       = b-prazo-compra.cc-codigo
                       b-prazo-compra.data-alter    = today
                       b-prazo-compra.usuario-alt   = c-seg-usuario
                       prazo-compra.nr-contrato     = b-prazo-compra.nr-contrato.
                
                FOR FIRST b-prazo-compra-aux NO-LOCK USE-INDEX ordem 
                    WHERE b-prazo-compra-aux.numero-ordem = p-numero-ordem AND
                          b-prazo-compra-aux.parcela      = p-parcela:
                    FIND FIRST eq-embarq-praz-compra NO-LOCK
                         WHERE eq-embarq-praz-compra.numero-ordem = b-prazo-compra-aux.numero-ordem
                           AND eq-embarq-praz-compra.parcela      = b-prazo-compra-aux.parcela NO-ERROR.
                    IF AVAIL eq-embarq-praz-compra  THEN DO:
                        FOR LAST b-eq-embarq-praz-compra-aux NO-LOCK USE-INDEX eqmbrqpr-id
                            WHERE b-eq-embarq-praz-compra-aux.cod-estabel = eq-embarq-praz-compra.cod-estabel
                              AND b-eq-embarq-praz-compra-aux.cod-placa   = eq-embarq-praz-compra.cod-placa
                              AND b-eq-embarq-praz-compra-aux.dat-entr    = eq-embarq-praz-compra.dat-entr
                              AND b-eq-embarq-praz-compra-aux.hra-entr    = eq-embarq-praz-compra.hra-entr: END.
                        CREATE b-eq-embarq-praz-compra.
                        BUFFER-COPY eq-embarq-praz-compra EXCEPT parcela num-seq TO b-eq-embarq-praz-compra NO-ERROR.
                        ASSIGN b-eq-embarq-praz-compra.num-seq = IF AVAIL b-eq-embarq-praz-compra-aux THEN 
                                                                     b-eq-embarq-praz-compra-aux.num-seq + 1 ELSE 1. 
                               b-eq-embarq-praz-compra.parcela = i-cont.
                    END.
                END.    
                /************ Inicio Chamada UPC PERKINS FO1183.941************/
                FOR EACH tt-epc 
                   WHERE tt-epc.cod-event = "quebraParcelaImp":U: 
                    DELETE tt-epc. 
                END.

                /*** Criacao do registro para temp-table tt-epc ***/
                {include/i-epc200.i2 &CodEvent='"quebraParcelaImp"'
                                     &CodParameter='"rw-prazo-compra-orig"'
                                     &ValueParameter=string(ROWID(prazo-compra))} /*prazo-compra alterado*/
                
                /*** Criacao do registro para temp-table tt-epc ***/
                {include/i-epc200.i2 &CodEvent='"quebraParcelaImp"'
                                     &CodParameter='"rw-prazo-compra-novo"'
                                     &ValueParameter=string(ROWID(b-prazo-compra))} /*prazo-compra criado*/
                                              
                /*** Chamada do programa EPC ***/
                {include/i-epc201.i "quebraParcelaImp"}

                IF RETURN-VALUE = "NOK" THEN
                    UNDO, LEAVE.
                /************ Fim Chamada UPC ************/

                &if defined(bf_mat_importacao_mrp) &then
                    {inbo/boin356aa.i2}
                &endif
                
                ASSIGN c-nr-parcela = c-nr-parcela + STRING(prazo-compra.parcela) + ",".
            END.

            create alt-ped.
            assign alt-ped.data         = today
                   alt-ped.hora         = string(TIME + 1,"HH:MM:SS")
                   alt-ped.usuario      = c-seg-usuario
                   alt-ped.num-pedido   = ordem-compra.num-pedido
                   alt-ped.numero-ordem = ordem-compra.numero-ordem
                   alt-ped.parcela      = prazo-compra.parcela
                   alt-ped.observacao   = "Inclus∆o Autom†tica de Parcela pelo M¢dulo de Importaá∆o. Nova Parcela."
                   alt-ped.data-entrega = da-data-entrega
                   alt-ped.quantidade   = ?
                   alt-ped.cod-cond-pag = ?
                   alt-ped.preco        = ?
                   alt-ped.char-1       = "0" + "|" + "?".
            
            IF  da-data-entrega <> prazo-compra.data-entrega THEN
                ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|" + string(prazo-compra.data-entrega,"99/99/9999").
            ELSE
                ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|" + "".
        end.        
    end.

    &if defined(bf_mat_importacao_mrp) &then
        if valid-handle (h-bocx150) then do:
            delete procedure h-bocx150.
            assign h-bocx150 = ?.
        end.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-nova-parcela-by-ordem DBOProgram 
PROCEDURE cria-nova-parcela-by-ordem :
define input parameter p-cod-estabel        like ordem-compra.cod-estabel  no-undo.
    define input parameter p-numero-ordem       like ordem-compra.numero-ordem no-undo.
    define input parameter p-quantidade         like prazo-compra.quantidade   no-undo.
    define input parameter p-embarque           like embarque-imp.embarque     no-undo.
    define input parameter p-nova-quantidade    like prazo-compra.quantidade   no-undo.
    define input parameter p-quantidade-n-emb   like prazo-compra.quantidade   no-undo.
    define input parameter p-nova-entrega       like prazo-compra.data-entrega no-undo.
    define output parameter p-nova-parcela      like prazo-compra.parcela      no-undo.
    
    define variable        i-cont               as   integer                   no-undo.
    define variable        v-quantidade         like prazo-compra.quantidade   no-undo.
    define variable        v-nova-qtde          like prazo-compra.quantidade   no-undo.
    define variable        v-qtde-ord-emb       like prazo-compra.quantidade   no-undo.
    define variable        l-ok                 as   logical                   no-undo.
    define variable        v-qtde-ordem         like prazo-compra.quantidade   no-undo.
    define variable        v-somador            like prazo-compra.quantidade   no-undo.
    define variable        da-data-entrega      as   date                      no-undo.
    
    define buffer          b-prazo-compra       for  prazo-compra.
    
    for each tt-prazo-compra:
        delete tt-prazo-compra.
    end.        

    &if defined(bf_mat_importacao_mrp) &then
        if not valid-handle (h-bocx150) then
            if connected("mgcex") then
                run cxbo/bocx150.p persistent set h-bocx150.
    &endif
    
    assign l-ok = no.
    
    find first ordem-compra no-lock
         where ordem-compra.cod-estabel  = p-cod-estabel
           and ordem-compra.numero-ordem = p-numero-ordem no-error.
    if not avail ordem-compra then leave.
    assign v-somador = 0.
    
    FIND FIRST ITEM WHERE
               ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

    for each  prazo-compra NO-LOCK 
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
        if can-find(first ordens-embarque 
                    where ordens-embarque.cod-estabel   = ordem-compra.cod-estabel
                    and   ordens-embarque.numero-ordem  = ordem-compra.numero-ordem
                    and   ordens-embarque.parcela       = prazo-compra.parcela)
        then do:
            for each  ordens-embarque no-lock
                where ordens-embarque.cod-estabel   = ordem-compra.cod-estabel
                and   ordens-embarque.numero-ordem  = ordem-compra.numero-ordem
                and   ordens-embarque.parcela       = prazo-compra.parcela :
                if prazo-compra.quantidade > v-somador
                then do:
                   assign v-somador = v-somador + ordens-embarque.quantidade.
                end.
            end.                
            IF v-somador = prazo-compra.quantidade 
            THEN ASSIGN V-SOMADOR = 0.
            ELSE DO:
                 create tt-prazo-compra.
                 buffer-copy prazo-compra to tt-prazo-compra.
                 assign v-quantidade = v-quantidade + prazo-compra.quantidade .
            END.                 
        end.            
        ELSE DO:
            create tt-prazo-compra.
            buffer-copy prazo-compra to tt-prazo-compra.
            assign v-quantidade = v-quantidade + prazo-compra.quantidade .
        END.                
        if v-quantidade >= p-nova-quantidade then leave.
    end.

    if (v-quantidade - p-nova-quantidade) <> 0 then do:
        assign v-nova-qtde      = p-nova-quantidade + v-somador
               v-quantidade     = 0
               v-qtde-ord-emb   = 0.
        
        for each tt-prazo-compra
            break by tt-prazo-compra.numero-ordem:
            for each ordens-embarque no-lock
                where ordens-embarque.cod-estabel   = p-cod-estabel
                and   ordens-embarque.numero-ordem  = p-numero-ordem:
                
                if ordens-embarque.embarque         = p-embarque 
                then next.
                else
                 assign v-qtde-ordem = v-qtde-ordem + ordens-embarque.quantidade. 
            end.            
            assign p-nova-quantidade = p-nova-quantidade + v-qtde-ordem.
            if v-quantidade < p-nova-quantidade then 
                assign v-quantidade = v-quantidade + tt-prazo-compra.quantidade
                       v-nova-qtde  = v-nova-qtde  - tt-prazo-compra.quantidade.
                
            if v-nova-qtde < 0 then
               assign v-nova-qtde = v-nova-qtde * (-1).
            
            if last-of(tt-prazo-compra.numero-ordem) then
            do:
               find first prazo-compra exclusive-lock 
                    where prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
                      and prazo-compra.parcela      = tt-prazo-compra.parcela 
                    no-error.
               if avail prazo-compra THEN do:         
                        
                   ASSIGN p-nova-quantidade         = IF   (prazo-compra.quantidade - v-nova-qtde) > 0 
                                                      THEN (prazo-compra.quantidade - v-nova-qtde)
                                                      ELSE (v-nova-qtde - prazo-compra.quantidade).

                   if prazo-compra.situacao <> 4 then do:
                        assign deIndice = 1.
                        if item.tipo-contr <> 4 then do:
                            find item-fornec where 
                                item-fornec.it-codigo    = prazo-compra.it-codigo and
                                item-fornec.cod-emitente = ordem-compra.cod-emitente and 
                                item-fornec.ativo          no-lock no-error.
                            if available item-fornec then
                                assign deIndice = item-fornec.fator-conver / exp(10, item-fornec.num-casa-dec).
                        end.
                        ASSIGN prazo-compra.qtd-do-forn = p-nova-quantidade * deIndice.
                   END.
                   

                   ASSIGN v-qtde-ordem              = prazo-compra.quantidade
                          prazo-compra.quantidade   = p-nova-quantidade
                          prazo-compra.qtd-sal-forn = /*p-nova-quantidade*/ prazo-compra.qtd-do-forn
                          prazo-compra.quant-saldo  = p-nova-quantidade.                          

                   if  not avail ordem-compra then
                       find ordem-compra EXCLUSIVE-LOCK where 
                            ordem-compra.numero-ordem = prazo-compra.numero-ordem no-error.
                            
                   if  avail ordem-compra then do:
                       find first pedido-compr no-lock 
                            where pedido-compr.num-pedido = ordem-compra.num-pedido   
                            no-error.
                       if avail pedido-compr 
                       and pedido-compr.situacao = 1 then do:
                           find emitente where emitente.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
                           IF date(substring(prazo-compra.char-2,1,10)) <> ? THEN
                              ASSIGN da-data-entrega = date(substring(prazo-compra.char-2,1,10)).
                           ELSE
                              ASSIGN da-data-entrega = prazo-compra.data-entrega.

                           create alt-ped.
                           assign alt-ped.data         = today
                                  alt-ped.hora         = string(time,"HH:MM:SS")
                                  alt-ped.usuario      = c-seg-usuario
                                  alt-ped.num-pedido   = ordem-compra.num-pedido
                                  alt-ped.numero-ordem = ordem-compra.numero-ordem
                                  alt-ped.parcela      = prazo-compra.parcela
                                  alt-ped.observacao   = "Inclus∆o Autom†tica de Parcela pelo M¢dulo de Importaá∆o."
                                  alt-ped.data-entrega = date(substring(prazo-compra.char-2,1,10))
                                  alt-ped.quantidade   = v-qtde-ordem
                                  alt-ped.cod-cond-pag = ?
                                  alt-ped.preco        = ?
                                  alt-ped.char-1       = "0" + "|" + string(prazo-compra.qtd-sal-forn).

                           IF  date(substring(prazo-compra.char-2,1,10)) <> prazo-compra.data-entrega THEN
                               ASSIGN alt-ped.char-1       = alt-ped.char-1 + "|" + string(p-nova-entrega,"99/99/9999").
                           ELSE
                               ASSIGN alt-ped.char-1       = alt-ped.char-1 + "|" + "".

                           if  avail emitente then       
                               assign alt-ped.nome-abrev   = emitente.nome-abrev.
                   
                           &if defined(bf_mat_compras_edi) &then
                               /* Atualiza dados do pedido e da ordem
                                  possibilitando extrair novamente
                                  os dados no EDI         */
                               assign ordem-compra.gera-edi = yes.   
                               find pedido-compr where pedido-compr.num-pedido = ordem-compra.num-pedido 
                                   exclusive-lock no-error.
                               if  avail pedido-compr then 
                                   assign pedido-compr.gera-edi = yes.
                               find current pedido-compr no-lock no-error.
                           &endif
                       end.            
                   end.
               end.
            
               find last prazo-compra NO-LOCK where 
                         prazo-compra.numero-ordem = ordem-compra.numero-ordem no-error.
               if avail prazo-compra then 
                  assign p-nova-parcela = prazo-compra.parcela + 1.
               
               if v-nova-qtde  - v-quantidade > 0 
               or v-quantidade - v-nova-qtde  > 0 
               and v-nova-qtde > 0 then do:
                  find last b-prazo-compra exclusive-lock
                       where b-prazo-compra.numero-ordem = p-numero-ordem no-error.
                  if avail b-prazo-compra then do:
                      create prazo-compra.
                      assign prazo-compra.numero-ordem    = b-prazo-compra.numero-ordem
                             prazo-compra.parcela         = p-nova-parcela             
                             prazo-compra.data-entrega    = p-nova-entrega
                             prazo-compra.quantidade      = v-nova-qtde 
                             prazo-compra.data-orig       = b-prazo-compra.data-orig
                             prazo-compra.it-codigo       = b-prazo-compra.it-codigo
                             prazo-compra.un              = b-prazo-compra.un   
                             prazo-compra.quantid-orig    = b-prazo-compra.quantid-orig
                             prazo-compra.quant-saldo     = v-nova-qtde 
                             prazo-compra.quant-rejeit    = b-prazo-compra.quant-rejeit
                             prazo-compra.quant-receb     = b-prazo-compra.quant-receb
                             prazo-compra.qtd-do-forn     = v-nova-qtde * deIndice 
                             prazo-compra.qtd-sal-forn    = prazo-compra.qtd-do-forn 
                             prazo-compra.qtd-rej-forn    = b-prazo-compra.qtd-rej-forn
                             prazo-compra.qtd-rec-forn    = b-prazo-compra.qtd-rec-forn
                             prazo-compra.pedido-clien    = b-prazo-compra.pedido-clien
                             prazo-compra.usuario-alt     = ""
                             prazo-compra.data-alter      = ?
                             prazo-compra.nome-abrev      = b-prazo-compra.nome-abrev
                             prazo-compra.nr-alt-data     = b-prazo-compra.nr-alt-data
                             prazo-compra.nr-alt-quant    = b-prazo-compra.nr-alt-quant 
                             prazo-compra.situacao        = b-prazo-compra.situacao
                             prazo-compra.natureza        = b-prazo-compra.natureza
                             prazo-compra.cod-refer       = b-prazo-compra.cod-refer 
                             prazo-compra.concentracao    = b-prazo-compra.concentracao 
                             prazo-compra.rendimento      = b-prazo-compra.rendimento 
                             prazo-compra.nr-sequencia    = b-prazo-compra.nr-sequencia 
                             prazo-compra.cc-codigo       = b-prazo-compra.cc-codigo
                             b-prazo-compra.data-alter    = today
                             b-prazo-compra.usuario-alt   = c-seg-usuario
                             prazo-compra.nr-contrato     = b-prazo-compra.nr-contrato.     

                      /************ Inicio Chamada UPC PERKINS FO1183.941************/
                      FOR EACH tt-epc 
                         WHERE tt-epc.cod-event = "quebraParcelaImp":U: 
                          DELETE tt-epc. 
                      END.
    
                      /*** Criacao do registro para temp-table tt-epc ***/
                      {include/i-epc200.i2 &CodEvent='"quebraParcelaImp"'
                                           &CodParameter='"rw-prazo-compra-orig"'
                                           &ValueParameter=string(ROWID(prazo-compra))} /*prazo-compra alterado*/
                    
                      /*** Criacao do registro para temp-table tt-epc ***/
                      {include/i-epc200.i2 &CodEvent='"quebraParcelaImp"'
                                           &CodParameter='"rw-prazo-compra-novo"'
                                           &ValueParameter=string(ROWID(b-prazo-compra))} /*prazo-compra criado*/
                                                   
                      /*** Chamada do programa EPC ***/
                      {include/i-epc201.i "quebraParcelaImp"}
    
                      IF RETURN-VALUE = "NOK" THEN
                          UNDO, LEAVE.
                      /************ Fim Chamada UPC ************/

                      &if defined(bf_mat_importacao_mrp) &then
                          {inbo/boin356aa.i2}
                      &endif
                  end.

                  create alt-ped.
                  assign alt-ped.data         = today
                         alt-ped.hora         = string(TIME + 1,"HH:MM:SS")
                         alt-ped.usuario      = c-seg-usuario
                         alt-ped.num-pedido   = ordem-compra.num-pedido
                         alt-ped.numero-ordem = ordem-compra.numero-ordem
                         alt-ped.parcela      = prazo-compra.parcela
                         alt-ped.observacao   = "Inclus∆o Autom†tica de Parcela pelo M¢dulo de Importaá∆o. Nova Parcela."
                         alt-ped.data-entrega = da-data-entrega
                         alt-ped.quantidade   = ?
                         alt-ped.cod-cond-pag = ?
                         alt-ped.preco        = ?
                         alt-ped.char-1       = "0" + "|" + "?".

                  IF  da-data-entrega <> prazo-compra.data-entrega THEN
                      ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|" + string(prazo-compra.data-entrega,"99/99/9999").
                  ELSE
                      ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|" + "".
               end.
            end.
        end.
    end.        
    else assign p-nova-parcela = ?.

    &if defined(bf_mat_importacao_mrp) &then
        if valid-handle (h-bocx150) then do:
            delete procedure h-bocx150.
            assign h-bocx150 = ?.
        end.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-nova-parcela-by-ordem-2 DBOProgram 
PROCEDURE cria-nova-parcela-by-ordem-2 :
    define input parameter  p-cod-estabel        like ordem-compra.cod-estabel  no-undo.
    define input parameter  p-numero-ordem       like ordem-compra.numero-ordem no-undo.
    define input parameter  p-quantidade         like prazo-compra.quantidade   no-undo.
    define input parameter  p-embarque           like embarque-imp.embarque     no-undo.
    define input parameter  p-nova-quantidade    like prazo-compra.quantidade   no-undo.
    define input parameter  p-quantidade-n-emb   like prazo-compra.quantidade   no-undo.
    define input parameter  p-nova-entrega       like prazo-compra.data-entrega no-undo.
    define output parameter p-nova-parcela       like prazo-compra.parcela      no-undo.

    define variable        i-cont               as   integer                   no-undo.
    define variable        v-quantidade         like prazo-compra.quantidade   no-undo.
    define variable        v-nova-qtde          like prazo-compra.quantidade   no-undo.
    define variable        v-qtde-ord-emb       like prazo-compra.quantidade   no-undo.
    define variable        l-ok                 as   logical                   no-undo.
    define variable        v-qtde-ordem         like prazo-compra.quantidade   no-undo.
    define variable        v-somador            like prazo-compra.quantidade   no-undo.
    define variable        da-data-entrega      as   date                      no-undo.
    
    define buffer          b-prazo-compra       for  prazo-compra.

    for each tt-prazo-compra:
        delete tt-prazo-compra.
    end.    

    &if defined(bf_mat_importacao_mrp) &then
        if not valid-handle (h-bocx150) then
            if connected("mgcex") then
                run cxbo/bocx150.p persistent set h-bocx150.
    &endif

    FIND FIRST param-global NO-LOCK NO-ERROR.
        
    assign l-ok = no.
    find first ordem-compra no-lock
         where ordem-compra.cod-estabel  = p-cod-estabel
           and ordem-compra.numero-ordem = p-numero-ordem no-error.
    if not avail ordem-compra then leave.
        assign v-somador = 0.
    FIND FIRST ITEM WHERE
               ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

    for each  prazo-compra NO-LOCK 
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
          and prazo-compra.situacao <> 4:
       
        if can-find(first ordens-embarque 
                    where ordens-embarque.cod-estabel   = ordem-compra.cod-estabel
                      and ordens-embarque.numero-ordem  = ordem-compra.numero-ordem
                      and ordens-embarque.parcela       = prazo-compra.parcela) then do:
            for each ordens-embarque no-lock
                where ordens-embarque.cod-estabel   = ordem-compra.cod-estabel
                  and ordens-embarque.numero-ordem  = ordem-compra.numero-ordem
                  and ordens-embarque.parcela       = prazo-compra.parcela :
                if prazo-compra.quantidade > v-somador then do:
                   assign v-somador = v-somador + ordens-embarque.quantidade.
                end.
            end.                
            if v-somador = prazo-compra.quantidade then do:
                assign v-quantidade = v-quantidade + v-somador
                       v-somador = 0.
                next.
            end.                
            else do:
                for each ordens-embarque no-lock
                    where ordens-embarque.cod-estabel   = ordem-compra.cod-estabel
                      and ordens-embarque.numero-ordem  = ordem-compra.numero-ordem
                      and ordens-embarque.parcela       = prazo-compra.parcela :                
                     create tt-prazo-compra.
                     buffer-copy prazo-compra to tt-prazo-compra.
                end.
            end.
        end.

        assign v-quantidade = v-quantidade + prazo-compra.quant-saldo /*prazo-compra.quantidade*/.
        
        if v-quantidade > p-nova-quantidade then leave.
    end.    
    
    if (v-quantidade - p-nova-quantidade) <> 0 THEN do:
        assign v-nova-qtde      = p-nova-quantidade
               v-quantidade     = 0.
        
        for each tt-prazo-compra
            break by tt-prazo-compra.numero-ordem:
            assign v-somador = 0
                   v-qtde-ord-emb   = 0.
            for each  ordens-embarque no-lock
                where ordens-embarque.numero-ordem  = tt-prazo-compra.numero-ordem
                and   ordens-embarque.parcela       = tt-prazo-compra.parcela :
                if ordens-embarque.embarque = p-embarque then
                    assign v-qtde-ord-emb = v-qtde-ord-emb + (tt-prazo-compra.quantidade - ordens-embarque.quantidade - v-nova-qtde).
                else 
                    assign v-somador = v-somador + ordens-embarque.quantidade.
            end.            
            if v-quantidade < p-nova-quantidade then 
                assign v-quantidade = (v-quantidade - v-somador) + tt-prazo-compra.quantidade
                       v-nova-qtde  = ((v-nova-qtde + v-qtde-ord-emb) + v-somador) - tt-prazo-compra.quantidade + tt-prazo-compra.quantidade.
                
            if v-nova-qtde < 0 then
               assign v-nova-qtde = v-nova-qtde * (-1).
            
            if last-of(tt-prazo-compra.numero-ordem) then do:
               find first prazo-compra exclusive-lock 
                    where prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
                      and prazo-compra.parcela      = tt-prazo-compra.parcela 
                    no-error.
               if avail prazo-compra then do:
                   assign p-nova-quantidade = if (prazo-compra.quantidade - v-nova-qtde) > 0 
                                              then (prazo-compra.quantidade - v-nova-qtde)
                                              else (v-nova-qtde - prazo-compra.quantidade).

                   if prazo-compra.situacao <> 4 then do:
                        assign deIndice = 1.
                        if item.tipo-contr <> 4 then do:
                            find first item-fornec no-lock
                                 where item-fornec.it-codigo    = prazo-compra.it-codigo 
                                   and item-fornec.cod-emitente = ordem-compra.cod-emitente
                                   and item-fornec.ativo no-error.
                            if available item-fornec then
                                assign deIndice = item-fornec.fator-conver / exp(10, item-fornec.num-casa-dec).
                        end.
                        assign prazo-compra.qtd-do-forn = p-nova-quantidade * deIndice.
                   end.
                   
                   assign v-qtde-ordem              = prazo-compra.quantidade
                          prazo-compra.quantidade   = p-nova-quantidade
                          prazo-compra.qtd-sal-forn = prazo-compra.qtd-do-forn
                          prazo-compra.quant-saldo  = p-nova-quantidade.
                          
                   if  not avail ordem-compra then
                       find first ordem-compra exclusive-lock 
                       where ordem-compra.numero-ordem = prazo-compra.numero-ordem no-error.
                            
                   if  avail ordem-compra then do:
                       find first pedido-compr no-lock 
                            where pedido-compr.num-pedido = ordem-compra.num-pedido   
                            no-error.
                       if avail pedido-compr 
                       and pedido-compr.situacao = 1 then do:
                           find first emitente no-lock
                                where emitente.cod-emitente = ordem-compra.cod-emitente no-error.
                           if date(substring(prazo-compra.char-2,1,10)) <> ? then
                              assign da-data-entrega = date(substring(prazo-compra.char-2,1,10)).
                           else
                              assign da-data-entrega = prazo-compra.data-entrega.

                           create alt-ped.
                           assign alt-ped.data         = today
                                  alt-ped.hora         = string(time,"HH:MM:SS")
                                  alt-ped.usuario      = c-seg-usuario
                                  alt-ped.num-pedido   = ordem-compra.num-pedido
                                  alt-ped.numero-ordem = ordem-compra.numero-ordem
                                  alt-ped.parcela      = prazo-compra.parcela
                                  alt-ped.observacao   = "Inclus∆o Autom†tica de Parcela pelo M¢dulo de Importaá∆o."
                                  alt-ped.data-entrega = date(substring(prazo-compra.char-2,1,10))
                                  alt-ped.quantidade   = v-qtde-ordem
                                  alt-ped.cod-cond-pag = ?
                                  alt-ped.preco        = ?
                                  alt-ped.char-1       = "0" + "|" + string(prazo-compra.qtd-sal-forn).

                           if date(substring(prazo-compra.char-2,1,10)) <> prazo-compra.data-entrega THEN
                               assign alt-ped.char-1       = alt-ped.char-1 + "|" + string(prazo-compra.data-entrega,"99/99/9999").
                           else
                               assign alt-ped.char-1       = alt-ped.char-1 + "|" + "".

                           if avail emitente then       
                               assign alt-ped.nome-abrev   = emitente.nome-abrev.
                   
                           &if defined(bf_mat_compras_edi) &then
                               /* Atualiza dados do pedido e da ordem
                                  possibilitando extrair novamente
                                  os dados no EDI         */
                               assign ordem-compra.gera-edi = yes.   
                               find pedido-compr where pedido-compr.num-pedido = ordem-compra.num-pedido 
                                   exclusive-lock no-error.
                               if  avail pedido-compr then 
                                   assign pedido-compr.gera-edi = yes.
                               find current pedido-compr no-lock no-error.
                           &endif
                       end.            
                   end.
               end.            
               
               find last prazo-compra no-lock 
                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-error.
               if avail prazo-compra then 
                  assign p-nova-parcela = prazo-compra.parcela + 1.
               if v-nova-qtde  - v-quantidade > 0 
               or v-quantidade - v-nova-qtde  > 0 
               and v-nova-qtde > 0 then do:

                  find first b-prazo-compra exclusive-lock
                       where b-prazo-compra.numero-ordem = p-numero-ordem
                         and b-prazo-compra.parcela      = tt-prazo-compra.parcela no-error.

                  if avail b-prazo-compra then do:
                      create prazo-compra.
                      assign prazo-compra.numero-ordem    = b-prazo-compra.numero-ordem
                             prazo-compra.parcela         = p-nova-parcela 
                             prazo-compra.data-entrega    = p-nova-entrega
                             prazo-compra.data-orig       = b-prazo-compra.data-orig
                             prazo-compra.quantidade      = v-nova-qtde 
                             prazo-compra.it-codigo       = b-prazo-compra.it-codigo
                             prazo-compra.un              = b-prazo-compra.un   
                             prazo-compra.quantid-orig    = b-prazo-compra.quantid-orig 
                             prazo-compra.quant-saldo     = v-nova-qtde 
                             prazo-compra.quant-rejeit    = b-prazo-compra.quant-rejeit
                             prazo-compra.quant-receb     = b-prazo-compra.quant-receb
                             prazo-compra.qtd-do-forn     = v-nova-qtde * deIndice 
                             prazo-compra.qtd-sal-forn    = prazo-compra.qtd-do-forn 
                             prazo-compra.qtd-rej-forn    = b-prazo-compra.qtd-rej-forn
                             prazo-compra.qtd-rec-forn    = b-prazo-compra.qtd-rec-forn
                             prazo-compra.pedido-clien    = b-prazo-compra.pedido-clien
                             prazo-compra.usuario-alt     = ""
                             prazo-compra.data-alter      = ?
                             prazo-compra.nome-abrev      = b-prazo-compra.nome-abrev
                             prazo-compra.nr-alt-data     = b-prazo-compra.nr-alt-data
                             prazo-compra.nr-alt-quant    = b-prazo-compra.nr-alt-quant 
                             prazo-compra.situacao        = b-prazo-compra.situacao
                             prazo-compra.natureza        = b-prazo-compra.natureza
                             prazo-compra.cod-refer       = b-prazo-compra.cod-refer 
                             prazo-compra.concentracao    = b-prazo-compra.concentracao 
                             prazo-compra.rendimento      = b-prazo-compra.rendimento 
                             prazo-compra.nr-sequencia    = b-prazo-compra.nr-sequencia 
                             prazo-compra.cc-codigo       = b-prazo-compra.cc-codigo
                             b-prazo-compra.data-alter    = today
                             b-prazo-compra.usuario-alt   = c-seg-usuario
                             prazo-compra.nr-contrato     = b-prazo-compra.nr-contrato.

                      /************ Inicio Chamada UPC PERKINS FO1183.941************/
                      FOR EACH tt-epc 
                         WHERE tt-epc.cod-event = "quebraParcelaImp":U: 
                          DELETE tt-epc. 
                      END.
    
                      /*** Criacao do registro para temp-table tt-epc ***/
                      {include/i-epc200.i2 &CodEvent='"quebraParcelaImp"'
                                           &CodParameter='"rw-prazo-compra-orig"'
                                           &ValueParameter=string(ROWID(prazo-compra))} /*prazo-compra alterado*/
                    
                      /*** Criacao do registro para temp-table tt-epc ***/
                      {include/i-epc200.i2 &CodEvent='"quebraParcelaImp"'
                                           &CodParameter='"rw-prazo-compra-novo"'
                                           &ValueParameter=string(ROWID(b-prazo-compra))} /*prazo-compra criado*/
                                                   
                      /*** Chamada do programa EPC ***/
                      {include/i-epc201.i "quebraParcelaImp"}
    
                      IF RETURN-VALUE = "NOK" THEN
                          UNDO, LEAVE.
                      /************ Fim Chamada UPC ************/

                      &if defined(bf_mat_importacao_mrp) &then
                          {inbo/boin356aa.i2}
                      &endif
                  end.
                  
                  create alt-ped.
                  assign alt-ped.data         = today
                         alt-ped.hora         = string(TIME + 1,"HH:MM:SS")
                         alt-ped.usuario      = c-seg-usuario
                         alt-ped.num-pedido   = ordem-compra.num-pedido
                         alt-ped.numero-ordem = ordem-compra.numero-ordem
                         alt-ped.parcela      = prazo-compra.parcela
                         alt-ped.observacao   = "Inclus∆o Autom†tica de Parcela pelo M¢dulo de Importaá∆o. Nova Parcela."
                         alt-ped.data-entrega = da-data-entrega
                         alt-ped.quantidade   = ?
                         alt-ped.cod-cond-pag = ?
                         alt-ped.preco        = ?
                         alt-ped.char-1       = "0" + "|" + "?".

                  IF  da-data-entrega <> prazo-compra.data-entrega THEN
                      ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|" + string(prazo-compra.data-entrega,"99/99/9999").
                  ELSE
                      ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|" + "".
               end.
            end.
        end.
    end.        
    else assign p-nova-parcela = ?.

    &if defined(bf_mat_importacao_mrp) &then
        if valid-handle (h-bocx150) then do:
            delete procedure h-bocx150.
            assign h-bocx150 = ?.
        end.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaLicenciamImportOC DBOProgram 
PROCEDURE criaLicenciamImportOC :
    /* Licenciamento Importacao */

    define input parameter iNumeroOrdem like ordem-compra.numero-ordem no-undo.
    define input parameter iParcela     like prazo-compra.parcela      no-undo.
    
    define variable hBocx351 as handle    no-undo.
    define variable cReturn  as character no-undo.
    
    empty temp-table tt-licenciam-import-oc-aux.
    
    if  not valid-handle(hBocx351) then
        run cxbo/bocx351.p persistent set hBocx351.
    
    run openQueryStatic in hBocx351 (input "Main":U).
    
    run piRetornaLI in hBocx351 (input 3,
                                 input no,
                                 input ?,
                                 input ?,
                                 input ?,
                                 input iParcela,
                                 input yes,
                                 input yes,
                                 input iNumeroOrdem,
                                 input iNumeroOrdem,
                                 input " ":U,
                                 input " ":U,
                                 input " ":U,
                                 input " ":U,
                                 input " ":U,
                                 input " ":U,
                                 output table tt-licenciam-import-oc).
    
    for first tt-licenciam-import-oc no-lock: end.
    if  avail tt-licenciam-import-oc then do:
    
        create tt-licenciam-import-oc-aux.
        assign tt-licenciam-import-oc-aux.numero-ordem   = prazo-compra.numero-ordem
               tt-licenciam-import-oc-aux.parcela        = prazo-compra.parcela
               tt-licenciam-import-oc-aux.licenca-import = tt-licenciam-import-oc.licenca-import.
    end.
    
    if  avail tt-licenciam-import-oc-aux then do:
    
        Records:
        do  transaction on error undo, leave:
    
            run emptyRowErrors in hBocx351.
            run emptyRowObject in hBocx351.
    
            run setRecord in hBocx351 (input table tt-licenciam-import-oc-aux).
            
            run createRecord in hBocx351.
            if  return-value = "NOK":U then do:
    
                run getRowErrors in hBocx351 (output table RowErrors).
    
                for each  RowErrors 
                    where RowErrors.errorType = "INTERNAL":U:
                    delete RowErrors.
                end.
    
                if  can-find (first RowErrors) then
                    undo Records, leave Records.
            end.
        end.
    end.
    
    if  valid-handle (hBocx351) then do:
        delete procedure hBocx351.
        assign hBocx351 = ?.
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTprazo DBOProgram 
PROCEDURE criaTTprazo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER v-cod-proces-imp-f      AS CHARACTER    nO-UNDO.
    DEFINE INPUT PARAMETER v-cod-proces-imp-i      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER v-num-ped-compra-f      AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER v-num-ped-compra-i      AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER v-num-ordem-compra-f    AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER v-num-ordem-compra-i    AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER v-cod-item-f            AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER v-cod-item-i            AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER v-dat-pedido-f          AS DATE         NO-UNDO.
    DEFINE INPUT PARAMETER v-dat-pedido-i          AS DATE         NO-UNDO.

    def var de-ord-emb     as decimal no-undo.
    def var de-total       as decimal no-undo.
    def var r-cotacao-item as rowid no-undo.
    
    def var v-somador      like ordens-embarque.quantidade no-undo.
    
    for each  tt-ordem-compra:
        delete tt-ordem-compra.
    end. 
    
    for each  tt-prazo-compra:
        delete tt-prazo-compra.
    end.
       
    FOR EACH tt-prazo-compra-aux.
        DELETE tt-prazo-compra-aux.
    END.

    for first embarque-imp field(cod-estabel cod-incoterm cdn-pto-embarq)
        where rowid(embarque-imp) = r-embarque no-lock:         
        
        for each processo-imp fields(situacao cod-itiner cod-estabel nr-proc-imp num-pedido) no-lock
            where processo-imp.cod-estabel = embarque-imp.cod-estabel 
              and processo-imp.nr-proc-imp >= v-cod-proces-imp-i 
              and processo-imp.nr-proc-imp <= v-cod-proces-imp-f use-index codigo:

            if processo-imp.situacao >= 3 then
               next.
            
            if processo-imp.num-pedido < v-num-ped-compra-i
            or processo-imp.num-pedido > v-num-ped-compra-f then
               next.

            FOR FIRST itinerario 
                WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK:
            END.
            IF NOT AVAIL itinerario THEN NEXT.


            FOR first param-imp FIELDS(hist-processo)
                where param-imp.cod-estabel = processo-imp.cod-estabel NO-LOCK:
            END.

            if not avail param-imp THEN next.

            IF param-imp.hist-processo THEN
                IF NOT CAN-FIND (FIRST historico-proc-imp
                    where historico-proc-imp.cod-estabel = processo-imp.cod-estabel 
                    and   historico-proc-imp.nr-proc-imp = processo-imp.nr-proc-imp) THEN NEXT.

            
            IF CAN-FIND (FIRST historico-proc-imp 
                         WHERE historico-proc-imp.cod-estabel   = processo-imp.cod-estabel 
                           AND historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp 
                           AND historico-proc-imp.cod-itiner    = processo-imp.cod-itiner  
                           AND ((embarque-imp.cdn-pto-embarq > 0 AND historico-proc-imp.cod-pto-contr = embarque-imp.cdn-pto-embarq) OR
                                (embarque-imp.cdn-pto-embarq <= 0 AND historico-proc-imp.cod-pto-contr = itinerario.pto-embarque))
                           AND historico-proc-imp.dt-efetiva    = ?) THEN NEXT.
            
            for first pedido-compr fields(num-pedido cod-emitente situacao data-pedido)
                where pedido-compr.num-pedido = processo-imp.num-pedido 
                  and pedido-compr.situacao = 1 no-lock:                 
               
               /* filtra ordens de determinado pedido - setconstraint3 ou 5 */
               if  i-num-pedido <> 0 
               and pedido-compr.num-pedido <> i-num-pedido then
                   next. 
               
               if pedido-compr.data-pedido < v-dat-pedido-i 
               or pedido-compr.data-pedido > v-dat-pedido-f then
                  next.
               
               for each ordem-compra 
                   where ordem-compra.num-pedido  = pedido-compr.num-pedido 
                     and ordem-compra.numero-ordem >= v-num-ordem-compra-i
                     and ordem-compra.numero-ordem <= v-num-ordem-compra-f
                     and ordem-compra.situacao = 2 no-lock:
                   
                   if ordem-compra.it-codigo < v-cod-item-i
                   or ordem-compra.it-codigo > v-cod-item-f then 
                      next.
                   
                   for each cotacao-item fields(cotacao-item.char-1)
                       where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       and   cotacao-item.cod-emitente = pedido-compr.cod-emitente 
                       and   cotacao-item.cot-aprovada no-lock:
                       {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                       {ccp/cc9019.i51 "yes"}
                       leave.                             
                   end.                                                    
                   if c-cod-incoterm-i50 <> embarque-imp.cod-incoterm then 
                      next.
                   
                   assign de-total   = 0
                          de-ord-emb = 0.
                   
                   for each prazo-compra no-lock
                      where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                       AND prazo-compra.situacao = 2:
                         
                           assign de-total = de-total + prazo-compra.quantidade.     
                           
                           for each ordens-embarque fields(quantidade)
                               where ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                               and   ordens-embarque.parcela      = prazo-compra.parcela
                               no-lock
                               USE-INDEX ordem:
                               assign de-ord-emb = de-ord-emb + ordens-embarque.quantidade.
                           end.
    
                           IF NOT CAN-FIND(FIRST tt-prazo-compra-aux 
                                           WHERE tt-prazo-compra-aux.r-rowid = ROWID(prazo-compra)) THEN DO:
                              create tt-prazo-compra-aux.
                              buffer-copy prazo-compra to tt-prazo-compra-aux.
                              assign tt-prazo-compra-aux.r-rowid = rowid(prazo-compra).
                           END.
                   end.

                   if de-total > de-ord-emb then do:
                      IF NOT CAN-FIND(FIRST tt-ordem-compra
                                      WHERE tt-ordem-compra.r-rowid = ROWID(ordem-compra)) THEN DO:
                         create tt-ordem-compra.
                         buffer-copy ordem-compra to tt-ordem-compra.
                         assign tt-ordem-compra.r-rowid = rowid(ordem-compra).
                      end.
                   end.
               end.
            end.
        end.             
        if can-find(first tt-ordem-compra) then do: 
            tt-ordem-compra:
            for each tt-ordem-compra
                use-index ch-ordem :

                if can-find (first contrato-for
                             where contrato-for.nr-contrato = tt-ordem-compra.nr-contrato
                               and (contrato-for.dt-ter-validade < today
                                or contrato-for.log-libera = no))
                or can-find (first item-contrat
                             where item-contrat.nr-contrato = tt-ordem-compra.nr-contrato
                               and item-contrat.it-codigo = tt-ordem-compra.it-codigo
                               and item-contrat.log-libera = no) then
                    next.
                
                for each tt-prazo-compra-aux no-lock 
                     where tt-prazo-compra-aux.numero-ordem = tt-ordem-compra.numero-ordem
                    use-index ordem:
                   
                    if not can-find (first ordens-embarque 
                                     where ordens-embarque.cod-estabel  = tt-ordem-compra.cod-estabel
                                     and   ordens-embarque.numero-ordem = tt-prazo-compra-aux.numero-ordem 
                                     and   ordens-embarque.parcela      = tt-prazo-compra-aux.parcela) then do: 
                       create tt-prazo-compra.
                       buffer-copy tt-prazo-compra-aux except quantidade to tt-prazo-compra .
                       assign tt-prazo-compra.r-rowid = tt-prazo-compra-aux.r-rowid.
                   end.               
                   else do:
                       assign v-somador = 0.
                       
                       for each  ordens-embarque fields(quantidade) no-lock
                           where ordens-embarque.numero-ordem = tt-prazo-compra-aux.numero-ordem 
                           and   ordens-embarque.parcela      = tt-prazo-compra-aux.parcela
                           use-index ordem:
                           assign v-somador = v-somador + ordens-embarque.quantidade.
                       end.

                       if v-somador <> tt-prazo-compra-aux.quantidade then do:
                           create tt-prazo-compra.
                           buffer-copy tt-prazo-compra-aux to tt-prazo-compra.

                           assign tt-prazo-compra.r-rowid      = tt-prazo-compra-aux.r-rowid
                                  tt-prazo-compra.quantidade   = v-somador - tt-prazo-compra-aux.quantidade
                                  tt-prazo-compra.qtd-sal-forn = v-somador - tt-prazo-compra-aux.qtd-sal-forn
                                  tt-prazo-compra.quant-saldo  = v-somador - tt-prazo-compra-aux.quant-saldo.
                           
                           if tt-prazo-compra.quantidade < 0 then
                              assign tt-prazo-compra.quantidade = tt-prazo-compra.quantidade * (-1).
                           IF tt-prazo-compra.qtd-sal-forn < 0 then
                              ASSIGN tt-prazo-compra.qtd-sal-forn = tt-prazo-compra.qtd-sal-forn * (-1).
                           IF tt-prazo-compra.quant-saldo < 0 then
                              ASSIGN tt-prazo-compra.quant-saldo = tt-prazo-compra.quant-saldo * (-1).
                       end.
                   end.
                end.

            end.        
        end.
    end.

end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                 BY {&table-name}.numero-ordem
                 BY {&table-name}.parcela.
        when 3 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
               BY {&table-name}.it-codigo
               BY {&table-name}.numero-ordem
               BY {&table-name}.parcela.
        when 5 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
               BY {&table-name}.data-entrega
               BY {&table-name}.numero-ordem
               BY {&table-name}.it-codigo.
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
{include/boprebro.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTprazo-compra DBOProgram 
PROCEDURE criaTTprazo-compra :
    def input param p-cod-estab-ini         like estabelec.cod-estabel.
    def input param p-cod-estab-fim         like estabelec.cod-estabel.
    def input param p-cod-proc-imp-ini      like processo-imp.nr-proc-imp.
    def input param p-cod-proc-imp-fim      like processo-imp.nr-proc-imp.
    def input param p-cod-fornec-ini        like fornecedor.cod-fornec.
    def input param p-cod-fornec-fim        like fornecedor.cod-fornec.
    def input param p-cod-ped-compra-ini    like pedido-compr.num-pedido.
    def input param p-cod-ped-compra-fim    like pedido-compr.num-pedido.
    def input param p-cod-ord-compra-ini    like ordem-compra.numero-ordem.
    def input param p-cod-ord-compra-fim    like ordem-compra.numero-ordem.
    def input param p-cod-incoterm-ini      like incoterm-itiner.cod-incoterm.
    def input param p-cod-incoterm-fim      like incoterm-itiner.cod-incoterm.
    def input param p-cod-item-ini          like item.it-codigo.
    def input param p-cod-item-fim          like item.it-codigo.
    def output parameter                    table for tt-prazo-compra.
    
    def buffer bf-ordens-embarque for ordens-embarque.
    def buffer bprazo-compra      for prazo-compra.
    
    def var r-cotacao-item as rowid   no-undo.
    def var v-data         as date    no-undo.
    def var i-qtde         like ordens-embarque.quantidade no-undo.
    
    for each  tt-ordem-compra:
        delete tt-ordem-compra.
    end.
    
    for each  tt-prazo-compra:
        delete tt-prazo-compra.
    end.    
    
    for each processo-imp no-lock
        where processo-imp.cod-estabel >= p-cod-estab-ini
          and processo-imp.cod-estabel <= p-cod-estab-fim
          and processo-imp.nr-proc-imp >= p-cod-proc-imp-ini
          and processo-imp.nr-proc-imp <= p-cod-proc-imp-fim:
        
        find first param-imp no-lock
             where param-imp.cod-estabel = processo-imp.cod-estabel no-error.
        
        if not avail param-imp then next.
         
        if processo-imp.situacao >= 3 then
           next.
        
        find itinerario 
           where itinerario.cod-itiner = processo-imp.cod-itiner 
           no-lock no-error.
        if avail itinerario then do:
           find first historico-proc-imp no-lock
                where historico-proc-imp.cod-estabel   = processo-imp.cod-estabel
                  and historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp
                  and historico-proc-imp.cod-itiner    = processo-imp.cod-itiner
                  and historico-proc-imp.cod-pto-contr = itinerario.pto-embarque no-error.
           if avail historico-proc-imp then do:
              if param-imp.hist-processo       = yes 
              and historico-proc-imp.dt-efetiva = ? then
                 next.
           end.
        end.                   
        find first pedido-compr no-lock
             where pedido-compr.num-pedido = processo-imp.num-pedido no-error.
        if avail pedido-compr then do:
           if pedido-compr.num-pedido < p-cod-ped-compra-ini or
              pedido-compr.num-pedido > p-cod-ped-compra-fim 
           then next.
           
           if pedido-compr.cod-emitente < p-cod-fornec-ini or
              pedido-compr.cod-emitente > p-cod-fornec-fim 
           then next. 
           
           if pedido-compr.situacao <> 1 then
              next.
            
           for each ordem-compra no-lock
               where ordem-compra.num-pedido  = pedido-compr.num-pedido:
               
               If ordem-compra.numero-ordem < p-cod-ord-compra-ini or
                  ordem-compra.numero-ordem > p-cod-ord-compra-fim
               then next.
               
               If ordem-compra.it-codigo < p-cod-item-ini or
                  ordem-compra.it-codigo > p-cod-item-fim
               then next.
               
               if ordem-compra.situacao <> 2 then 
                  next.

               if can-find (first contrato-for
                            where contrato-for.nr-contrato = ordem-compra.nr-contrato
                              and (contrato-for.dt-ter-validade < today
                               or contrato-for.log-libera       = no
                               or contrato-for.ind-sit-contrat  = 3)) /* Cancelado */
               or can-find (first item-contrat
                            where item-contrat.nr-contrato = ordem-compra.nr-contrato
                              and item-contrat.it-codigo     = ordem-compra.it-codigo
                              and (item-contrat.log-libera   = no
                               or item-contrat.ind-sit-item >= 3)) /* 3 - Cancelado, 4 - Atendido  */ then
                   next.
               
               for each cotacao-item fields(cot-aprovada char-1)
                   where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   and   cotacao-item.cod-emitente = pedido-compr.cod-emitente 
                   no-lock:
                   
                   if substring(cotacao-item.char-1,21,20) < p-cod-incoterm-ini or
                      substring(cotacao-item.char-1,21,20) > p-cod-incoterm-fim 
                   then next.
                   
                   if cotacao-item.cot-aprovada then do:
                      {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                      {ccp/cc9019.i51 "yes"}
                      leave.
                   end.                            
               end.                                
               for each prazo-compra no-lock
                   where prazo-compra.numero-ordem = ordem-compra.numero-ordem:

                   if prazo-compra.situacao <> 2 then
                      next.

                   if can-find(first contrato-for
                               where contrato-for.nr-contrato = ordem-compra.nr-contrato
                                 and contrato-for.dt-ini-validade > prazo-compra.data-entrega) then
                       next.
                   
                   find first ordens-embarque  NO-LOCK
                        where ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                          and ordens-embarque.parcela      = prazo-compra.parcela  no-error.
                   if not avail ordens-embarque then do: 
                       create tt-prazo-compra.
                       buffer-copy prazo-compra to tt-prazo-compra.
                       assign tt-prazo-compra.r-rowid = rowid(prazo-compra).
                   end.               
                   else do:
                       assign i-qtde = 0.
                       for each  bf-ordens-embarque no-lock
                           where bf-ordens-embarque.numero-ordem = ordens-embarque.numero-ordem 
                           and   bf-ordens-embarque.parcela      = ordens-embarque.parcela:
                           assign i-qtde = i-qtde + bf-ordens-embarque.quantidade.
                       end.
                       if i-qtde < prazo-compra.quantidade then do:
                           create tt-prazo-compra.
                           buffer-copy prazo-compra to tt-prazo-compra.
                           assign tt-prazo-compra.r-rowid = rowid(prazo-compra).    
                           for each  ordens-embarque no-lock
                               where ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                                 and ordens-embarque.parcela      = prazo-compra.parcela:
                                
                                find first bprazo-compra no-lock
                                     where bprazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                                       and bprazo-compra.parcela      = ordens-embarque.parcela no-error.

                                if bprazo-compra.situacao <> 2 then  
                                   next.

                                assign tt-prazo-compra.quantidade  = tt-prazo-compra.quantidade  - i-qtde
                                       tt-prazo-compra.quant-saldo = prazo-compra.quantidade     - i-qtde
                                       tt-prazo-compra.qtd-do-forn = tt-prazo-compra.qtd-do-forn - i-qtde.
                           end.
                           
                           if tt-prazo-compra.quantidade < 0 then
                               assign tt-prazo-compra.quantidade  = tt-prazo-compra.quantidade  * (-1).
                           if tt-prazo-compra.quant-saldo < 0 then
                               assign tt-prazo-compra.quant-saldo = tt-prazo-compra.quant-saldo * (-1).       
                           if tt-prazo-compra.qtd-do-forn < 0 then
                               assign tt-prazo-compra.qtd-do-forn = tt-prazo-compra.qtd-do-forn * (-1).
                       end.
                   end.                      
               end.
           end.
        end.
    end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParcelaCriada DBOProgram 
PROCEDURE getParcelaCriada :
DEFINE OUTPUT PARAMETER p-nr-parcela AS CHAR    NO-UNDO.
    ASSIGN p-nr-parcela = c-nr-parcela.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ordem
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

    FIND FIRST bfprazo-compra WHERE 
        bfprazo-compra.numero-ordem = pnumero-ordem AND 
        bfprazo-compra.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprazo-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprazo-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-erro DBOProgram 
PROCEDURE retorna-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter i-msg as integer no-undo.
    define input  parameter c-msg as char    no-undo.
    define input  parameter i-seq as integer no-undo.
    define output parameter table for tt-bo-erro.
    
    {utp/ut-table.i mgadm tt-bo-erro 1}

    run utp/ut-msgs.p (input "msg",
                           input i-msg,
                       input c-msg).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq
            tt-bo-erro.cd-erro  = i-msg
            tt-bo-erro.mensagem = return-value.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-estab-ordem DBOProgram 
PROCEDURE retorna-estab-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-numero-ordem   like ordem-compra.numero-ordem  no-undo.
    DEFINE OUTPUT PARAMETER p-cod-estabel    like ordem-compra.cod-estabel   no-undo.
    
    find first ordem-compra no-lock
         where ordem-compra.numero-ordem = p-numero-ordem no-error.
    if avail ordem-compra then do:
        assign p-cod-estabel = ordem-compra.cod-estabel.
    end.
    else assign p-cod-estabel = "". 
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RetornaDataEntregaNovaParcela DBOProgram 
PROCEDURE RetornaDataEntregaNovaParcela :
    DEFINE INPUT  PARAMETER p-cod-estabel  LIKE ordem-compra.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER p-nova-data    AS   DATE                      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-data-entrega AS   DATE                      NO-UNDO.
    
    assign p-data-entrega = ?.
    
    find first param-imp no-lock 
         where param-imp.cod-estabel = p-cod-estabel no-error.
    if avail param-imp and 
             param-imp.int-1 = 2 then 
    do:     
        find first ordem-compra no-lock 
             where ordem-compra.numero-ordem = p-numero-ordem 
             and   ordem-compra.cod-estabel  = p-cod-estabel no-error.
        if avail ordem-compra then
        do:  
            find processo-imp 
                where processo-imp.cod-estabel = ordem-compra.cod-estabel
                and   processo-imp.num-pedido  = ordem-compra.num-pedido no-lock no-error.    
            if not avail processo-imp then do:
                undo, return.
            end.
            
            if processo-imp.situacao >= 3 then do:
                undo, return.
            end.
            
            find itinerario 
                where itinerario.cod-itiner = processo-imp.cod-itiner no-lock no-error.     
            if not avail itinerario then do:
                undo, return.
            end.

            find first pto-itiner no-lock 
                 where pto-itiner.cod-itiner    = processo-imp.cod-itiner 
                 and   pto-itiner.cod-pto-contr = itinerario.pto-embarque no-error.
                    
            if avail pto-itiner then do:
                repeat:
                    FIND NEXT  pto-itiner NO-LOCK 
                         WHERE pto-itiner.cod-itiner = processo-imp.cod-itiner NO-ERROR.
                    if avail pto-itiner then do:
                        assign p-nova-data = p-nova-data + pto-itiner.nr-dias.
                        if pto-itiner.cod-pto-contr = itinerario.pto-chegada then leave.
                    end.
                    else leave. 
                end. /*repeat*/
                assign p-data-entrega = p-nova-data.
            end.            
        end.
    end.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaestabelecimentoprazocompra DBOProgram 
PROCEDURE retornaestabelecimentoprazocompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input  parameter p-rowid         as rowid no-undo.
define output parameter p-cod-estabel   as char  no-undo.

find first prazo-compra no-lock
     where rowid(prazo-compra) = p-rowid no-error.
if avail prazo-compra then
do:
   find first ordem-compra 
        where ordem-compra.numero-ordem = prazo-compra.numero-ordem
         no-lock no-error.
   if avail ordem-compra 
   then assign p-cod-estabel = ordem-compra.cod-estabel.
   else assign p-cod-estabel = "".
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornapedido DBOProgram 
PROCEDURE retornapedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter p-numero-ordem  like ordem-compra.numero-ordem no-undo.
    define output parameter p-numero-pedido as   integer                   no-undo.
    
    for first ordem-compra fields(num-pedido) no-lock
         where ordem-compra.numero-ordem = p-numero-ordem: end.
    if avail ordem-compra then
       assign p-numero-pedido = ordem-compra.num-pedido.
    else assign p-numero-pedido = ?.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaTTprazoCompra DBOProgram 
PROCEDURE retornaTTprazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output parameter table for tt-prazo-compra.
    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE return-last-parcela DBOProgram 
PROCEDURE return-last-parcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input  parameter p-cod-estabel  like ordem-compra.cod-estabel no-undo.
define input  parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.
define output parameter p-last-parcela like prazo-compra.parcela     no-undo.
find first ordem-compra no-lock 
     where ordem-compra.cod-estabel  = p-cod-estabel
     and   ordem-compra.numero-ordem = p-numero-ordem no-error.
if avail ordem-compra then      
   find last  prazo-compra NO-LOCK 
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-error.
   if avail prazo-compra then 
      assign p-last-parcela = prazo-compra.parcela + 1.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose: recebe numero do embarque e executa a procedure que vai montar a 
           temp-table prazo-compra.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-chave                 AS ROWID        NO-UNDO.
    DEFINE INPUT PARAMETER v-cod-proces-imp-f      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER v-cod-proces-imp-i      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER v-num-ped-compra-f      AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER v-num-ped-compra-i      AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER v-num-ordem-compra-f    AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER v-num-ordem-compra-i    AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER v-cod-item-f            AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER v-cod-item-i            AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER v-dat-pedido-f          AS DATE         NO-UNDO.
    DEFINE INPUT PARAMETER v-dat-pedido-i          AS DATE         NO-UNDO.

    
    ASSIGN r-embarque = r-chave.
    RUN criaTTprazo(INPUT v-cod-proces-imp-f,  
                    INPUT v-cod-proces-imp-i,  
                    INPUT v-num-ped-compra-f,  
                    INPUT v-num-ped-compra-i,  
                    INPUT v-num-ordem-compra-f,
                    INPUT v-num-ordem-compra-i,
                    INPUT v-cod-item-f,        
                    INPUT v-cod-item-i,        
                    INPUT v-dat-pedido-f,      
                    INPUT v-dat-pedido-i).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose: recebe numero da ordem para filtrar prazos de compra de uma determinada
           ordem de compra
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter p-numero-ordem like ordem-compra.numero-ordem.

   assign i-numero-ordem = p-numero-ordem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint4 DBOProgram 
PROCEDURE setConstraint4 :
/*------------------------------------------------------------------------------
  Purpose:  recebe numero do embarque e executa a procedure que vai montar a 
            temp-table de prazo-compra.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter r-chave as rowid no-undo.
    
    assign r-embarque = r-chave.
    
    run criaTTprazo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint5 DBOProgram 
PROCEDURE setConstraint5 :
/*------------------------------------------------------------------------------
  Purpose:  recebe numero do pedido e executa a procedure que vai montar a 
            temp-table de prazo-compra.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter p-num-pedido like ordem-compra.numero-ordem.

   assign i-num-pedido = p-num-pedido.

END PROCEDURE.

PROCEDURE serverSendRows :

    /*
    **  messageonivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
    DEFine input  parameter piStartRow     as  integer   no-undo.
    DEFine input  parameter pcRowIdent     as  character no-undo.
    DEFine input  parameter plNext         as  logical   no-undo.
    DEFine input  parameter piRowsToReturn as  integer   no-undo.
    DEFine output parameter piRowsReturned as  integer   no-undo.
    DEFine output parameter table          for RowObject.
 
    DEFine variable hQuery        as handle    no-undo.
    DEFine variable hBuffer       as handle    no-undo.
    DEFine variable hRowObject    as handle    no-undo.
    DEFine variable hDataQuery    as handle    no-undo.
    DEFine variable cRowIdent     as character no-undo.
    DEFine variable rRowIDs       as rowid     extent 10 no-undo.
    DEFine variable lOK           as logical   no-undo.
    DEFine variable iRow          as integer   no-undo.
 
    for each RowObject:
        delete RowObject.
    end.
    IF true THEN DO:
        IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN DO:
            rRowIDs = ?.
            reposition {&query-name} to rowid to-rowid(pcRowIdent) no-error.
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow no-error.
            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE true:
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:
                create RowObject.
                buffer-copy {&table-name} to RowObject.
                /* assign RowObject.r-rowid = {&table-name}.r-rowid. */
                assign RowObject.r-rowid = rowid({&table-name}).
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
                REPOSITION  {&query-name} TO ROW (piStartRow) no-error.
        END.
    END.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


