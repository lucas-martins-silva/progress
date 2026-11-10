&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX312B 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX312B MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName Pedido-drb
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName Pedido-drb
&GLOBAL-DEFINE TableLabel Pedido-drb
&GLOBAL-DEFINE QueryName qr{&TableName}


/*--- Include com defini‡Æo da temptable RowObject ---*/
def var i-seq-erro  as int no-undo.
def var i-increment as int     no-undo.

/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/

{cxbo/bocx312.i RowObject}
{cxbo/bocx312.i tt-ped-drb}
{include/boerrtab.i}
{inbo/boin111a.i tt-item-estrut} /* Defini‡Æo TempTable Estrutura do Item */
{exp/ex4328.i}                   /* Defini‡Æo TempTable Componente Drawback */

DEFINE TEMP-TABLE tt-componente NO-UNDO LIKE movind.componente
       field it-codigo-pai    like componente.it-codigo
       field r-rowid          as   rowid
       field r-row-saldo-terc as   rowid
       field r-row-tt-it-doc  as   rowid
       field RowNum           as   integer.
    
def var h-boin111db   as handle  no-undo.
def var h-boin053db  as handle  no-undo.
def var h-boin404db  as handle  no-undo.
    
/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-tt-componente-drb FOR tt-componente-drb.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.14
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

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* **********************  Internal Procedures  *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaDrawback DBOProgram 
PROCEDURE efetivaDrawback:
/*
    **
    ** Objetivo: atualiza os itens controlados por Drawback.
    **
    */
    DEFINE input parameter r-rowid-nota-fiscal  as rowid no-undo.
    DEFINE input parameter r-rowid-it-nota-fisc as rowid no-undo.    
    
    def var c-it-codigo  as char    no-undo.
    def var d-quantidade as decimal no-undo.    
    
    /*
    ** Procura Nota Fiscal
    */
    for first nota-fiscal fields(nr-nota-fis serie nat-operacao cod-emitente)
        where rowid(nota-fiscal) = r-rowid-nota-fiscal no-lock:
    end.
    
    /*
    ** Procura Item da Nota Fiscal
    */
    for first it-nota-fisc fields(it-codigo nr-seq-fat cod-refer qt-faturada it-codigo)
        where rowid(it-nota-fisc) = r-rowid-it-nota-fisc no-lock:
    end.
    
    if not avail nota-fiscal or
       not avail it-nota-fisc then
        return.
        
    for each tt-item-estrut:
        delete tt-item-estrut.
    end.
    
    /*
    ** BO Componente
    */
    run inbo/boin053db.p persistent  set h-boin053db.
    run inbo/boin111db.p  persistent set h-boin111db.
    run inbo/boin404db.p persistent  set h-boin404db.    

    find first tt-componente-drb
       where tt-componente-drb.it-codigo-pai = it-nota-fisc.it-codigo 
         and tt-componente-drb.int-1         = it-nota-fisc.nr-seq-fat no-error.
    if not avail tt-componente-drb then do:
        
        /*
        ** BO Estrutura
        */
        run setConstraint2 in h-boin111db (input it-nota-fisc.cod-refer,
                                          input string(it-nota-fisc.qt-faturada[1]),
                                          input "19",
                                          input string(today),
                                          input ">>>>>,>>9.9999",
                                          input it-nota-fisc.it-codigo).
        run montaEstrutura in h-boin111db.
        run getTTEstrutura in h-boin111db (output table tt-item-estrut).        
    
        /*
        ** BO saldo-terc
        */        
        run setConstraint1      in h-boin404db (input table tt-item-estrut).
        run carregaTTSaldoTerc  in h-boin404db (input table tt-saldo-terc-drb,
                                                input "").                                                
        run retornaSaldoTercAux in h-boin404db (output table tt-saldo-terc-drb).
        
        for each tt-item-estrut:
            
            if tt-item-estrut.quant-usada <= 0 then
                next.
            
            for each tt-saldo-terc-drb
                where tt-saldo-terc-drb.it-codigo = tt-item-estrut.it-codigo,
                first pedido-drb no-lock
                   where pedido-drb.nr-ato-concessorio = tt-saldo-terc-drb.nr-ato-concessorio
                      by pedido-drb.data-validade-ato:
                run criaTTComponenteAuxAutomatico in h-boin053db 
                    (input rowid(it-nota-fisc),
                     input-output table tt-componente-drb,
                     output table tt-componente-rest,
                     input tt-saldo-terc-drb.r-rowid,
                     input tt-item-estrut.quant-usada,
                     input-output table tt-saldo-terc-drb,
                     input table tt-item-estrut,
                     input yes,
                     output table tt-bo-erro).
            end.
        end.
        for each tt-componente-drb:
            RUN geraSaldoTercDrb (input yes).
        end.
    end.
    else do:
        for each tt-componente-drb:
            run geraSaldoTercDrb (input no).
        end.
    end.
    
    delete procedure h-boin053db.
    delete procedure h-boin111db.
    delete procedure h-boin404db.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraSaldoTercDrb DBOProgram 
PROCEDURE geraSaldoTercDrb :
/*
    **
    ** Procedimento: geraSaldoTercDrb
    ** Objetivo: Gera saldo terc para itens drawback.
    **
    */
    def input parameter l-verificar as log no-undo.    
    
    
    create tt-componente.
    assign tt-componente.cod-emitente       = tt-componente-drb.emite-comp
           tt-componente.nro-docto          = nota-fiscal.nr-nota-fis
           tt-componente.serie-docto        = nota-fiscal.serie
           tt-componente.nat-operacao       = nota-fiscal.nat-operacao
           tt-componente.it-codigo          = tt-componente-drb.it-codigo
           tt-componente.cod-refer          = tt-componente-drb.cod-refer
           tt-componente.componente         = 2
           tt-componente.nr-ato-concessorio = tt-componente-drb.nr-ato-concessorio
           tt-componente.baixa-ce           = no
           tt-componente.serie-comp         = tt-componente-drb.serie-comp
           tt-componente.nro-comp           = tt-componente-drb.nro-comp
           tt-componente.nat-comp           = tt-componente-drb.nat-comp
           tt-componente.seq-comp           = tt-componente-drb.seq-comp
           tt-componente.emite-comp         = nota-fiscal.cod-emitente
           tt-componente.quantidade         = tt-componente-drb.quantidade
           tt-componente.un                 = tt-componente-drb.un.
    
    if l-verificar = no then
        assign  tt-componente.sequencia   = it-nota-fisc.nr-seq-fat + i-increment.
    else
        assign  tt-componente.sequencia   = it-nota-fisc.nr-seq-fat.
             
    assign i-increment = i-increment + 10.
    find first tt-componente-rest 
        where tt-componente-rest.serie-comp = tt-componente.serie-comp
          and tt-componente-rest.nro-comp   = tt-componente.nro-comp
          and tt-componente-rest.nat-comp   = tt-componente.nat-comp
          and tt-componente-rest.seq-comp   = tt-componente.seq-comp no-error.
    if avail tt-componente-rest then do:
        
        assign tt-componente-rest.cod-emitente = tt-componente-drb.emite-comp 
               tt-componente-rest.nro-docto    = nota-fiscal.nr-nota-fis 
               tt-componente-rest.serie-docto  = nota-fiscal.serie
               tt-componente-rest.nat-operacao = nota-fiscal.nat-operacao
               tt-componente-rest.sequencia    = it-nota-fisc.nr-seq-fat
               tt-componente-rest.componente   = 2
               tt-componente-rest.baixa-ce     = no
               tt-componente-rest.un           = tt-componente-drb.un.

    end.
    
    find first tt-componente-rest no-error.
    run createComponente in h-boin053db (input table tt-componente,
                                         input table tt-componente-rest,
                                         input tt-componente.it-codigo,
                                         input tt-componente.sequencia).
    delete tt-componente.
    delete tt-componente-drb.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter i-abertura as integer no-undo.
 
    case i-abertura:
        when 1 then 
           run openQueryStatic ("Main").
        when 2 then 
           run openQueryStatic ("CodEstabel").
        end. /*end case*/
        
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb NO-LOCK by Pedido-drb.nr-ato-concessorio.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebeTTComponenteDrb DBOProgram 
PROCEDURE recebeTTComponenteDrb :
/*
**
** Objetivo: Receber os valores da tt-componente-drb.
**
*/

define input parameter table for tt-componente-drb.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


