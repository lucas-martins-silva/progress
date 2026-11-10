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
{include/i-prgvrs.i BOIN318 2.00.01.013 } /*** "010113" 27/10/2023 17:03:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin318 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName pl-prod
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName pl-prod
&GLOBAL-DEFINE TableLabel pl-prod
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 cd-plano /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin318.i RowObject}
{java/boRest.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgman.i} /*Miniflexibilizaá∆o. Utilizado no EMS 2.02  e EMS 2.03- NAO ELIMINAR
                 * Vari†vel preprocessador bf_man_sfc_lc e bf_man_203*/

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* variaveis necessarias aos setConstraint's */

   define var v_cd_plano like pl-it-prod.cd-plano no-undo.
   define var v_inicial as char no-undo.
   define var v_final   as char no-undo.

/* variaveis para procedures internas de negocio */
   
   def var i-per-inf   as integer no-undo.
   def var i-peri-grav as integer no-undo.
   def var i-perf-grav as integer no-undo.
   def var i-b-per     as integer no-undo.

   def var h-bomf320   as handle no-undo.

DEFINE BUFFER bftipo-per FOR tipo-per.
DEFINE BUFFER bfperiodo  FOR periodo.

DEFINE TEMP-TABLE RowObjectExtra NO-UNDO
    FIELD r-Rowid         AS ROWID
    FIELD tipo            AS INTEGER
    FIELD dt-inicio-i     AS DATE
    FIELD dt-termino-i    AS DATE
    FIELD dt-inicio-f     AS DATE
    FIELD dt-termino-f    AS DATE
    FIELD plan-horiz-fixo AS CHAR
    FIELD demanda-comp    AS CHAR
    FIELD demanda-fabr    AS CHAR
    FIELD rem-con-comp    AS LOG
    FIELD ent-con-comp    AS LOG
    FIELD rem-ben-comp    AS LOG
    FIELD ent-ben-comp    AS LOG
    FIELD rem-ben-fab     AS LOG
    FIELD ent-ben-fab     AS LOG
    FIELD rem-con-fab     AS LOG
    FIELD ent-con-fab     AS LOG
    FIELD rep-oc-and      AS LOG
    FIELD rep-op-and      AS LOG
    FIELD tp-rep-comp     AS CHAR
    FIELD tp-rep-fabr     AS CHAR
    FIELD desc-tipo       AS CHAR.
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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 18.04
         WIDTH              = 35.14.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
      &IF DEFINED (bf_man_204) &THEN

          find first param-crp no-lock no-error.
          if avail param-crp then do:

             create crp-plano.
              buffer-copy param-crp to crp-plano
                  assign crp-plano.cd-plano             = pl-prod.cd-plano
                         crp-plano.num-calc-plano       = pl-prod.cd-plano * 1000
                         crp-plano.dat-inic-period-calc = pl-prod.data-inicio
                         crp-plano.dat-fim-period-calc  = pl-prod.data-termino
                         crp-plano.log-recalc-crp       = true.

          end.

          if pl-prod.log-multi-estabel = yes then do:
             run mfbo/bomf320.p persistent set h-bomf320.
             
             run criaplprodestrut in h-bomf320 (input pl-prod.cd-plano).
             
             return "OK":U.
             
             run destroy in h-bomf320.
          end.

          ASSIGN pl-prod.log-pv-config = NO.
        
      &ENDIF
      
      /* Ao criar o plano, cria tambÇm as relaá‰es do plano com todos os estabelecimentos */

      FOR EACH estabelec NO-LOCK:
          CREATE pl-prod-estab.

          ASSIGN pl-prod-estab.cd-plano    = RowObject.cd-plano
                 pl-prod-estab.cod-estabel = estabelec.cod-estabel.
          
      END.            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var h-handle as handle no-undo.

    find first crp-plano exclusive-lock where
               crp-plano.cd-plano = RowObject.cd-plano no-error.
    if avail crp-plano then do:

        run mrbo/bomr105.p persistent set h-handle.
        run eliminaRelac in h-handle (crp-plano.num-calc-plano).
        run destroy in h-handle.

        delete crp-plano.
    
    end.

    FOR EACH planej-produc-histor 
        WHERE planej-produc-histor.cdn-plano = RowObject.cd-plano EXCLUSIVE-LOCK:
        DELETE planej-produc-histor.
    END.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaValoresIniciais DBOProgram 
PROCEDURE carregaValoresIniciais :
/*------------------------------------------------------------------------------
  Purpose: Procura pelo primeiro Plano Ativo. Caso ache, retornar† o C¢digo do
           Plano (cd-plano), o Per°odo Inicial (nr-per-ini), o Ano Inicial
           (ano-per-ini), e por fim o Estabelecimento (caso este possua algum).
  Parameters: i-par1: p-it-codigo
              i-par2: p-cod-refer
              o-par1: p-cd-plano
              o-par2: p-nr-per-ini
              o-par3: p-ano-per-ini
              o-par4: p-cod-estabel
  Notes:
------------------------------------------------------------------------------*/
&IF DEFINED (bf_man_203) &THEN

    define input  parameter p-it-codigo         as character no-undo.
    define input  parameter p-cod-refer         as character no-undo.

    define output parameter p-cd-plano          as integer   no-undo.
    define output parameter p-nr-per-ini        as integer   no-undo.
    define output parameter p-ano-per-ini       as integer   no-undo.
    define output parameter p-cod-estabel       as character no-undo.

    define variable         pcreturn      as character no-undo.

    RUN openQueryStatic (input "Main":U).
    run goToKeyEstado (input 1).
    if return-value = "OK" then do:
        assign pcreturn = "". /* esse e o valor esperado nas interfaces 1.1 */
            if rowObject.log-multi-estabel = yes then do:
                find first it-periodo where it-periodo.num-calc-plano  = rowObject.num-calc-plano  and
                                            it-periodo.it-codigo       = p-it-codigo               and
                                            it-periodo.cod-refer       = p-cod-refer               and
                                            it-periodo.ano             = rowObject.ano-per-ini     and
                                            it-periodo.periodo         = rowObject.nr-per-ini NO-LOCK no-error.
                if avail it-periodo then
                    assign p-cod-estabel = it-periodo.cod-estabel.
            end.
        assign p-cd-plano           = rowObject.cd-plano
               p-nr-per-ini         = rowObject.nr-per-ini
               p-ano-per-ini        = rowObject.ano-per-ini.
    end.
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind pl-prod 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
    end.

&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaEspPlano DBOProgram 
PROCEDURE copiaEspPlano :
/*------------------------------------------------------------------------------
  Purpose:     Faz uma c¢pia de um plano original para outro (pl0301a).
               Copia tambÇm os itens do plano
  Parameters:  i - plano original, i - plano destino
               i - ano inicial, i - per°odo inicial,
               o - rowid do plano criado.
  Notes:       
------------------------------------------------------------------------------*/
   
   def input param i-cd-plano-orig as integer.
   def input param i-cd-plano-dest as integer.
   def input param i-ano-ini       as integer.
   def input param i-per-ini       as integer.
   def output param rw-plano       as rowid.
   
   def buffer b-pl-it-prod for pl-it-prod.
   
   run goToKey in this-procedure (input i-cd-plano-orig).
   assign i-per-inf   = int(string(i-ano-ini, "9999") + string(i-per-ini,"999")).
   assign i-peri-grav = int(string(bfpl-prod.ano-per-ini,"9999") +
                        string(bfpl-prod.nr-per-ini,"999")).
   assign i-perf-grav = int(string(bfpl-prod.ano-per-fim,"9999") +
                        string(bfpl-prod.nr-per-fim,"999")).

   if i-per-inf >= i-peri-grav and 
      i-per-inf <= i-perf-grav then do:
      create pl-prod.
      buffer-copy bfpl-prod EXCEPT bfpl-prod.num-calc-plano to pl-prod
      assign pl-prod.cd-plano       = i-cd-plano-dest
             pl-prod.ano-per-ini    = i-ano-ini
             pl-prod.nr-per-ini     = i-per-ini
             pl-prod.num-calc-plano = 0
             pl-prod.log-pv-config = NO.
      assign rw-plano = rowid(pl-prod).  

      find first param-crp no-lock no-error.
      if avail param-crp then do:
         create crp-plano.
          buffer-copy param-crp to crp-plano
              assign crp-plano.cd-plano             = pl-prod.cd-plano
                     crp-plano.num-calc-plano       = pl-prod.cd-plano * 1000
                     crp-plano.dat-inic-period-calc = pl-prod.data-inicio
                     crp-plano.dat-fim-period-calc  = pl-prod.data-termino
                     crp-plano.log-recalc-crp       = true.
      end.
      
      &IF DEFINED (bf_man_204) &THEN

      if pl-prod.log-multi-estabel = yes then do:
         run mfbo/bomf320.p persistent set h-bomf320.
         
         run criaplprodestrut in h-bomf320 (input pl-prod.cd-plano).
         
         for each b-pl-it-prod of bfpl-prod NO-LOCK:
             assign i-b-per = int(string(b-pl-it-prod.ano,"9999") + string(b-pl-it-prod.periodo,"999")).
             if i-b-per >= i-per-inf then do:
                create pl-it-prod.
                assign pl-it-prod.cd-plano     = pl-prod.cd-plano
                       &IF DEFINED (bf_man_203) &THEN
                       pl-it-prod.cod-estabel  = b-pl-it-prod.cod-estabel
                       &ENDIF
                       pl-it-prod.it-codigo    = b-pl-it-prod.it-codigo
                       pl-it-prod.ano          = b-pl-it-prod.ano
                       pl-it-prod.periodo      = b-pl-it-prod.periodo
                       pl-it-prod.quantidade   = b-pl-it-prod.quantidade
                       pl-it-prod.dt-termino   = b-pl-it-prod.dt-termino
                       pl-it-prod.nome-abrev   = b-pl-it-prod.nome-abrev
                       pl-it-prod.nr-pedcli    = b-pl-it-prod.nr-pedcli
                       pl-it-prod.nr-sequencia = b-pl-it-prod.nr-sequencia
                       pl-it-prod.cod-gr-cli   = b-pl-it-prod.cod-gr-cli
                       pl-it-prod.cod-refer    = b-pl-it-prod.cod-refer
                       pl-it-prod.origem       = b-pl-it-prod.origem.
             end.
         end.

         return "OK":U.
         
         run destroy in h-bomf320.
      end.
      &ENDIF
   end.                                   
   else do:
        {method/svc/errors/inserr.i &ErrorNumber="7199"
                                    &ErrorType="EMS"
                                    &ErrorParameters="''"}
        RETURN "NOK":U.
        leave.
   end.

   for each b-pl-it-prod of bfpl-prod NO-LOCK:
       assign i-b-per = int(string(b-pl-it-prod.ano,"9999") + string(b-pl-it-prod.periodo,"999")).
       if i-b-per >= i-per-inf then do:
          create pl-it-prod.
          assign pl-it-prod.cd-plano     = pl-prod.cd-plano
                 &IF DEFINED (bf_man_203) &THEN
                 pl-it-prod.cod-estabel  = b-pl-it-prod.cod-estabel
                 &ENDIF
                 pl-it-prod.it-codigo    = b-pl-it-prod.it-codigo
                 pl-it-prod.ano          = b-pl-it-prod.ano
                 pl-it-prod.periodo      = b-pl-it-prod.periodo
                 pl-it-prod.quantidade   = b-pl-it-prod.quantidade
                 pl-it-prod.dt-termino   = b-pl-it-prod.dt-termino
                 pl-it-prod.nome-abrev   = b-pl-it-prod.nome-abrev
                 pl-it-prod.nr-pedcli    = b-pl-it-prod.nr-pedcli
                 pl-it-prod.nr-sequencia = b-pl-it-prod.nr-sequencia
                 pl-it-prod.cod-gr-cli   = b-pl-it-prod.cod-gr-cli
                 pl-it-prod.cod-refer    = b-pl-it-prod.cod-refer
                 pl-it-prod.origem       = b-pl-it-prod.origem.
       end.
   end.

   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaEspQuantidade DBOProgram 
PROCEDURE copiaEspQuantidade :
/*------------------------------------------------------------------------------
  Purpose:     Faz uma c¢pia especial dos itens do plano de um per°odo para outro
  Parameters:  i - c¢digo do plano destino, i - c¢digo do plano origem, i - ano inicial
               i - per°odo inicial
               i - novo ano, i - novo per°odo, i - atualiza quantidade
  Notes:       l-resposta = atualiza quantidade.
------------------------------------------------------------------------------*/
   
   def input param i-cd-plano as integer.
   def input param i-cd-plano-2 as integer.
   def input param i-ano-ini  as integer.
   def input param i-per-ini  as integer.
   def input param i-ano-ini2 as integer.
   def input param i-per-ini2 as integer.
   def input param l-resposta as logical.

   DEFINE VARIABLE multi-estabel-1 AS LOGICAL INITIAL NO NO-UNDO.
   DEFINE VARIABLE multi-estabel-2 AS LOGICAL INITIAL NO NO-UNDO.
   DEFINE VARIABLE copia-multi-estabel AS LOGICAL INITIAL NO NO-UNDO.
   
   def buffer b-pl-it-prod for pl-it-prod.

   run goToKey in this-procedure (input i-cd-plano).
   
   /*
     Verifica se o plano origem Ç multi estabelecimento,
     se o plano destino N«O for multi estabelecimento, n∆o copia os estabelecimentos.
   */
   FIND FIRST pl-prod WHERE pl-prod.cd-plano = i-cd-plano NO-LOCK NO-ERROR.
   IF AVAIL pl-prod THEN
        ASSIGN multi-estabel-1 = pl-prod.log-multi-estabel.

   FIND FIRST pl-prod WHERE pl-prod.cd-plano = i-cd-plano-2 NO-LOCK NO-ERROR.
   IF AVAIL pl-prod THEN
        ASSIGN multi-estabel-2 = pl-prod.log-multi-estabel.

   IF NOT multi-estabel-1 AND multi-estabel-2 THEN
       ASSIGN copia-multi-estabel = NO.
   ELSE
       ASSIGN copia-multi-estabel = YES.
   /* Fim da verificaá∆o */

   assign i-per-inf   = int(string(i-ano-ini,"9999") + 
                        string(i-per-ini,"999")).
   assign i-peri-grav = int(string(bfpl-prod.ano-per-ini,"9999") +
                        string(bfpl-prod.nr-per-ini,"999")).
   assign i-perf-grav = int(string(bfpl-prod.ano-per-fim,"9999") +
                        string(bfpl-prod.nr-per-fim,"999")).  
                        
   for each b-pl-it-prod where 
          b-pl-it-prod.cd-plano = i-cd-plano-2 and
          b-pl-it-prod.ano      = i-ano-ini and
          b-pl-it-prod.periodo  = i-per-ini NO-LOCK:
          create pl-it-prod.
          assign pl-it-prod.cd-plano    = i-cd-plano
                 pl-it-prod.it-codigo   = b-pl-it-prod.it-codigo
                 pl-it-prod.ano         = i-ano-ini2
                 pl-it-prod.periodo     = i-per-ini2.
       
                 &IF DEFINED (bf_man_203) &THEN 
                     IF copia-multi-estabel THEN
                        ASSIGN pl-it-prod.cod-estabel = b-pl-it-prod.cod-estabel.
                 &ENDIF
                 
          if l-resposta then 
             assign pl-it-prod.quantidade = b-pl-it-prod.quantidade.
 
          find periodo where periodo.cd-tipo   = pl-prod.cd-tipo and 
                             periodo.ano       = pl-it-prod.ano and
                             periodo.nr-periodo = pl-it-prod.periodo no-lock.
                       
          assign pl-it-prod.dt-termino   = periodo.dt-termino
                 pl-it-prod.nome-abrev   = b-pl-it-prod.nome-abrev
                 pl-it-prod.nr-pedcli    = b-pl-it-prod.nr-pedcli
                 pl-it-prod.nr-sequencia = b-pl-it-prod.nr-sequencia
                 pl-it-prod.cod-gr-cli   = b-pl-it-prod.cod-gr-cli
                 pl-it-prod.cod-refer    = b-pl-it-prod.cod-refer
                 pl-it-prod.origem       = b-pl-it-prod.origem.
   end.
          
      find pl-prod where pl-prod.cd-plano = i-cd-plano-2 EXCLUSIVE-LOCK.
      assign i-per-inf = int(string(i-ano-ini2,"9999") + 
                         string(i-per-ini2,"999")).

   if i-per-inf < i-peri-grav then do:
         assign pl-prod.ano-per-ini = i-ano-ini2.
         assign pl-prod.nr-per-ini  = i-per-ini2.
   end.   
   else do:
         IF pl-prod.nr-per-fim < i-per-ini AND pl-prod.ano-per-fim <= i-ano-ini THEN DO:
             assign pl-prod.ano-per-fim = i-ano-ini
                    pl-prod.nr-per-fim =  i-per-ini.
         END.
         ELSE DO:
            IF i-per-ini2 > pl-prod.nr-per-fim AND i-ano-ini2 >= pl-prod.ano-per-fim THEN DO:
               assign pl-prod.ano-per-fim = i-ano-ini2
                      pl-prod.nr-per-fim =  i-per-ini2.              
            END.           
      END.
   end.       
   
   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRelacionamentos DBOProgram 
PROCEDURE deleteRelacionamentos :
/*------------------------------------------------------------------------------
  Purpose:     Elimina os relacionamentos do Plano de Produá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED (bf_man_203) &THEN
    /*** Eliminaá∆o de estabelecimentos do plano ***/
    for each pl-prod-estab where
             pl-prod-estab.cd-plano = RowObject.cd-plano :
         delete pl-prod-estab.
    end.

    /*** Eliminaá∆o de planejamento do item do plano ***/
    for each pl-it-prod where 
             pl-it-prod.cd-plano = RowObject.cd-plano:
        delete pl-it-prod.
    end. 

    /*** Eliminaá∆o de planejamento do itens calculados no plano ***/
    for each pl-it-calc where
             pl-it-calc.cd-plano = RowObject.cd-plano:
        delete pl-it-calc.
    end.   

    /*** Eliminaá∆o de registros de c†lculo no MRP ***/
    for each pl-carga-maq where
             pl-carga-maq.num-calc-plano >= RowObject.cd-plano * 1000 and
             pl-carga-maq.num-calc-plano <= RowObject.num-calc-plano:
        delete pl-carga-maq.
    end.

    for each ordem-reprog where
             ordem-reprog.num-calc-plano >= RowObject.cd-plano * 1000 and
             ordem-reprog.num-calc-plano <= RowObject.num-calc-plano:
        delete ordem-reprog.
    end.

    for each res-aber where
             res-aber.num-calc-plano >= RowObject.cd-plano * 1000 and
             res-aber.num-calc-plano <= RowObject.num-calc-plano:
        delete res-aber.
    end.

    for each it-periodo where
             it-periodo.num-calc-plano >= RowObject.cd-plano * 1000 and
             it-periodo.num-calc-plano <= RowObject.num-calc-plano:

        for each ord-aber where
                 ord-aber.num-id-it-periodo = it-periodo.num-id-it-periodo:
            delete ord-aber.
        end.         

        for each it-per-proc where
                 it-per-proc.num-id-it-periodo = it-periodo.num-id-it-periodo:
            delete it-per-proc.
        end.         


        delete it-periodo.
    end.

    for each pl-ext-item where
             pl-ext-item.num-calc-plano >= RowObject.cd-plano * 1000 and
             pl-ext-item.num-calc-plano <= RowObject.num-calc-plano:
        delete pl-ext-item.
    end.

    /*** Eliminaá∆o do plano de consulta e calculo 2.04 ***/
    for each  pl-prod-estrut 
        where pl-prod-estrut.cd-plano-consulta = RowObject.cd-plano EXCLUSIVE-LOCK:
        delete pl-prod-estrut.
    end.
    
    for each  pl-prod-estrut
        where pl-prod-estrut.cd-plano-calculo = RowObject.cd-plano EXCLUSIVE-LOCK:
        delete pl-prod-estrut.
    end.    

&ENDIF

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaItensPlano DBOProgram 
PROCEDURE eliminaItensPlano :
/*------------------------------------------------------------------------------
  Purpose:     Elimina os itens do plano
  Parameters:  i - c¢digo do plano, i - data inicial, i - data final
  Notes:       
------------------------------------------------------------------------------*/
def input param i-cod-plano as int.
def input param da-data-ini as date.
def input param da-data-fim as date.

if da-data-ini = ? and da-data-fim = ? then 
    for each  pl-it-prod 
        where pl-it-prod.cd-plano = i-cod-plano EXCLUSIVE-LOCK:
        delete pl-it-prod.
    end.
else
    for each  pl-it-prod 
        where pl-it-prod.cd-plano = i-cod-plano
        and  (pl-it-prod.dt-termino < da-data-ini 
        or    pl-it-prod.dt-termino > da-data-fim) EXCLUSIVE-LOCK:
        delete pl-it-prod.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo Ìndice, caso n„o ache, retorna
        mensagem de erro padr„o do  EMS
  Parameters: ipar:pcd-plano:Plano
     
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter pcd-plano as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input pcd-plano).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "h-fim-net":U THEN ASSIGN pFieldValue = RowObject.h-fim-net.
        WHEN "h-ini-net":U THEN ASSIGN pFieldValue = RowObject.h-ini-net.
        WHEN "hora-inicio":U THEN ASSIGN pFieldValue = RowObject.hora-inicio.
        WHEN "hora-termino":U THEN ASSIGN pFieldValue = RowObject.hora-termino.
        WHEN "tipo-plano":U THEN ASSIGN pFieldValue = RowObject.tipo-plano.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCurrentRowid DBOProgram 
PROCEDURE getCurrentRowid :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o rowid do registro atual
  Parameters:  output = rowid do registro
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.
        
    assign pRowid = RowObject.r-rowid.
    
    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-inicio":U THEN ASSIGN pFieldValue = RowObject.data-inicio.
        WHEN "data-termino":U THEN ASSIGN pFieldValue = RowObject.data-termino.
        WHEN "dt-fim-net":U THEN ASSIGN pFieldValue = RowObject.dt-fim-net.
        WHEN "dt-ini-net":U THEN ASSIGN pFieldValue = RowObject.dt-ini-net.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-res-plan":U THEN ASSIGN pFieldValue = RowObject.nr-res-plan.
        WHEN "ano-per-fim":U THEN ASSIGN pFieldValue = RowObject.ano-per-fim.
        WHEN "ano-per-ini":U THEN ASSIGN pFieldValue = RowObject.ano-per-ini.
        WHEN "calculo":U THEN ASSIGN pFieldValue = RowObject.calculo.
        WHEN "calculo-plano":U THEN ASSIGN pFieldValue = RowObject.calculo-plano.
        WHEN "cd-plano":U THEN ASSIGN pFieldValue = RowObject.cd-plano.
        WHEN "cd-tipo":U THEN ASSIGN pFieldValue = RowObject.cd-tipo.
        WHEN "dt-validade":U THEN ASSIGN pFieldValue = RowObject.dt-validade.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "pl-estado":U THEN ASSIGN pFieldValue = RowObject.pl-estado.
        WHEN "tp-rep-comp":U THEN ASSIGN pFieldValue = RowObject.tp-rep-comp.
        WHEN "tp-rep-fabr":U THEN ASSIGN pFieldValue = RowObject.tp-rep-fabr.
        WHEN "nr-ord-rep":U THEN ASSIGN pFieldValue = RowObject.nr-ord-rep.
        WHEN "nr-per-fim":U THEN ASSIGN pFieldValue = RowObject.nr-per-fim.
        WHEN "nr-per-ini":U THEN ASSIGN pFieldValue = RowObject.nr-per-ini.
        WHEN "nr-res-comp":U THEN ASSIGN pFieldValue = RowObject.nr-res-comp.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "it-dem-dep":U THEN ASSIGN pFieldValue = RowObject.it-dem-dep.
        WHEN "it-dem-ind":U THEN ASSIGN pFieldValue = RowObject.it-dem-ind.
        WHEN "it-fabr":U THEN ASSIGN pFieldValue = RowObject.it-fabr.
        WHEN "nr-dias-seg":U THEN ASSIGN pFieldValue = RowObject.nr-dias-seg.
        WHEN "nr-it-net":U THEN ASSIGN pFieldValue = RowObject.nr-it-net.
        WHEN "nr-item-pedi":U THEN ASSIGN pFieldValue = RowObject.nr-item-pedi.
        WHEN "nr-ord-comp":U THEN ASSIGN pFieldValue = RowObject.nr-ord-comp.
        WHEN "nr-ord-fabr":U THEN ASSIGN pFieldValue = RowObject.nr-ord-fabr.
        WHEN "nr-ord-plan":U THEN ASSIGN pFieldValue = RowObject.nr-ord-plan.
        
        &IF DEFINED (bf_man_203) &THEN
        WHEN "num-calc-plano":U THEN ASSIGN pFieldValue = RowObject.num-calc-plano.        
        &ENDIF
        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CODIGO
  Parameters:
               retorna valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcd-plano LIKE pl-prod.cd-plano NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcd-plano = RowObject.cd-plano.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ordens-comp":U THEN ASSIGN pFieldValue = RowObject.ordens-comp.
        WHEN "ordens-fabr":U THEN ASSIGN pFieldValue = RowObject.ordens-fabr.
        WHEN "aprov-comp":U THEN ASSIGN pFieldValue = RowObject.aprov-comp.
        WHEN "aprov-fabr":U THEN ASSIGN pFieldValue = RowObject.aprov-fabr.
        WHEN "benef-comp":U THEN ASSIGN pFieldValue = RowObject.benef-comp.
        WHEN "benef-fabr":U THEN ASSIGN pFieldValue = RowObject.benef-fabr.
        WHEN "consig-comp":U THEN ASSIGN pFieldValue = RowObject.consig-comp.
        WHEN "consig-fabr":U THEN ASSIGN pFieldValue = RowObject.consig-fabr.
        WHEN "pedidos-comp":U THEN ASSIGN pFieldValue = RowObject.pedidos-comp.
        WHEN "pedidos-fabr":U THEN ASSIGN pFieldValue = RowObject.pedidos-fabr.
        WHEN "quant-confirm":U THEN ASSIGN pFieldValue = RowObject.quant-confirm.
        WHEN "rastreamento":U THEN ASSIGN pFieldValue = RowObject.rastreamento.
        WHEN "regera-plano":U THEN ASSIGN pFieldValue = RowObject.regera-plano.
        WHEN "res-comp":U THEN ASSIGN pFieldValue = RowObject.res-comp.
        WHEN "res-fabr":U THEN ASSIGN pFieldValue = RowObject.res-fabr.
        WHEN "saldo-comp":U THEN ASSIGN pFieldValue = RowObject.saldo-comp.
        WHEN "saldo-fabr":U THEN ASSIGN pFieldValue = RowObject.saldo-fabr.
        WHEN "tp-res-comp":U THEN ASSIGN pFieldValue = RowObject.tp-res-comp.
        WHEN "tp-res-fabr":U THEN ASSIGN pFieldValue = RowObject.tp-res-fabr.
        WHEN "tp-seg-comp":U THEN ASSIGN pFieldValue = RowObject.tp-seg-comp.
        WHEN "tp-seg-fabr":U THEN ASSIGN pFieldValue = RowObject.tp-seg-fabr.
        WHEN "tran-comp":U THEN ASSIGN pFieldValue = RowObject.tran-comp.
        WHEN "tran-fabr":U THEN ASSIGN pFieldValue = RowObject.tran-fabr.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        &IF DEFINED (bf_man_sfc_lc) &THEN
        when "log-pv-config":U THEN ASSIGN pFieldValue = RowObject.log-pv-config.
        &ENDIF 
        &IF DEFINED (bf_man_203) &THEN
        when "log-multi-estabel":U THEN ASSIGN pFieldValue = RowObject.log-multi-estabel.
        when "log-rb-compr":U  THEN ASSIGN pFieldValue = RowObject.log-rb-compr.
        when "log-eb-compr":U  THEN ASSIGN pFieldValue = RowObject.log-eb-compr.
        when "log-rc-compr":U  THEN ASSIGN pFieldValue = RowObject.log-rc-compr.
        when "log-ec-compr":U  THEN ASSIGN pFieldValue = RowObject.log-ec-compr.
        when "log-rb-fabric":U THEN ASSIGN pFieldValue = RowObject.log-rb-fabric.
        when "log-eb-fabric":U THEN ASSIGN pFieldValue = RowObject.log-eb-fabric.
        when "log-rc-fabric":U THEN ASSIGN pFieldValue = RowObject.log-rc-fabric.
        when "log-ec-fabric":U THEN ASSIGN pFieldValue = RowObject.log-ec-fabric.
        &ENDIF
	when "log-dispon-aloc-saldo" then ASSIGN pFieldValue = RowObject.log-dispon-aloc-saldo.

        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPlanoRowid DBOProgram 
PROCEDURE getPlanoRowid :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona o registro de acordo com o rowid enviado
  Parameters:  input - rowid do registro solicitado
  Notes:       
------------------------------------------------------------------------------*/

def input param prowid as rowid no-undo.

find first pl-prod 
     where rowid(pl-prod) = prowid no-lock no-error.
     
if avail pl-prod then
   run goToKey (input pl-prod.cd-plano).
else return "NOK":U.
        
RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice CODIGO
  Parameters:
               recebe valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-plano LIKE pl-prod.cd-plano NO-UNDO.

    FIND FIRST bfpl-prod WHERE
        bfpl-prod.cd-plano = pcd-plano
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyEstado DBOProgram 
PROCEDURE goToKeyEstado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-estado as integer NO-UNDO.

    find first bfpl-prod 
         where bfpl-prod.pl-estado = p-estado
         no-lock no-error.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
    
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
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
       case i-abertura:
           when 1 then
              RUN openQueryStatic (input "Main":U). 
              
           when 2 then
              RUN openQueryStatic (input "CdPlano":U).
           
           when 3 then
              RUN openQueryStatic (input "FiltroCdPlano":U).
              
           when 4 then
              RUN openQueryStatic (input "FiltroDescricao":U).
   
           
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCdPlano DBOProgram 
PROCEDURE openQueryCdPlano :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela pl-prod conforme
               o cÛdigo do plano.
      
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.cd-plano = v_cd_plano NO-LOCK  INDEXED-REPOSITION.
                                          
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroCdPlano DBOProgram 
PROCEDURE openQueryFiltroCdPlano :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela pl-prod, dentro
              de uma faixa de cÛdigo do plano inicial e cÛdigo do plano final. 
     
------------------------------------------------------------------------------*/
open query {&QUERYNAME} for each {&TABLENAME} where
                                 {&TABLENAME}.cd-plano >= int(v_inicial) AND
                                 {&TABLENAME}.cd-plano <= int(v_final)
                                  NO-LOCK  INDEXED-REPOSITION.
                                          
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroDescricao DBOProgram 
PROCEDURE openQueryFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela pl-prod, dentro de 
              uma faixa de descriÁ„o inicial e final, estado do plano 
              inicial e final. 
  
------------------------------------------------------------------------------*/
open query {&QUERYNAME} for each {&TABLENAME} where
                                 {&TABLENAME}.descricao >= v_inicial AND
                                 {&TABLENAME}.descricao <= v_final   AND
                                 {&TABLENAME}.pl-estado >= int(v_inicial) AND
                                 {&TABLENAME}.pl-estado <= int(v_final)
                                  NO-LOCK  INDEXED-REPOSITION.
                                          
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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari·veis de controle
               para queries contendo o cÛdigo do plano.
  Parameters:  ipar:pcd_plano: Plano        
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    DEFINE INPUT PARAMETER pcd_plano LIKE pl-it-prod.cd-plano NO-UNDO.
    
    run setConstraintCdPlano (pcd_plano).
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari·veis de controle para queries contendo o
               cÛdigo inicial e final do plano.
  Parameters:  ipar1:pinicial:Plano Inicial
               ipar2:pfinal: Plano Final
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter pinicial as char no-undo.
    define input parameter pfinal   as char no-undo.
    
    run setConstraintFiltroCdPlano (pinicial,
                                    pfinal).
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCdPlano DBOProgram 
PROCEDURE setConstraintCdPlano :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari·veis de controle
               para queries contendo o cÛdigo do plano.
  Parameters:  ipar:pcd_plano: Plano    
  ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd_plano LIKE pl-it-prod.cd-plano NO-UNDO.
    
    assign v_cd_plano = pcd_plano.

                                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroCdPlano DBOProgram 
PROCEDURE setConstraintFiltroCdPlano :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari·veis de controle para queries contendo o
               cÛdigo inicial e final do plano.
  Parameters:  ipar1:pinicial:Plano Inicial
               ipar2:pfinal: Plano Final
------------------------------------------------------------------------------*/
    define input parameter pinicial as char no-undo.
    define input parameter pfinal   as char no-undo.
    
       assign v_inicial = pinicial.
       assign v_final   = pfinal.

                                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create":U THEN DO:
        IF CAN-FIND(pl-prod
                    WHERE pl-prod.cd-plano = RowObject.cd-plano) THEN 
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-plano-producao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Plano_Produá∆o" *}
            ASSIGN c-lbl-liter-plano-producao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                     &ErrorNumber="7"
                     &ErrorType="EMS"
                     &ErrorParameters="c-lbl-liter-plano-producao"}
            END. 
    END.

    IF pType = "Create":U or pType = "Update":U  THEN DO: 
        find first periodo where periodo.cd-tipo    = RowObject.cd-tipo     and 
                                 periodo.ano        = RowObject.ano-per-ini and 
                                 periodo.nr-periodo = RowObject.nr-per-ini  no-lock no-error.
        if  not avail periodo then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-anoperiodo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ano/Per°odo" *}
            ASSIGN c-lbl-liter-anoperiodo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                     &ErrorNumber="56"
                     &ErrorType="EMS"
                     &ErrorParameters="c-lbl-liter-anoperiodo"}
        end.
      
        find first periodo where periodo.cd-tipo    = RowObject.cd-tipo     and 
                                 periodo.ano        = RowObject.ano-per-fim and 
                                 periodo.nr-periodo = RowObject.nr-per-fim  no-lock no-error.
        if  not avail periodo then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-anoperiodo-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ano/Per°odo" *}
            ASSIGN c-lbl-liter-anoperiodo-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                     &ErrorNumber="56"
                     &ErrorType="EMS"
                     &ErrorParameters="c-lbl-liter-anoperiodo-2"}
        end.

        if RowObject.cd-plano = 0 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-plano AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Plano" *}
            ASSIGN c-lbl-liter-plano = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                     &ErrorNumber="4803"
                     &ErrorType="EMS"
                     &ErrorParameters="c-lbl-liter-plano"}
        end.

        
        if  RowObject.ano-per-fim < RowObject.ano-per-ini then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-periodoano AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Per°odo/Ano" *}
            ASSIGN c-lbl-liter-periodoano = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                     &ErrorNumber="354"
                     &ErrorType="EMS"
                     &ErrorParameters="c-lbl-liter-periodoano"}
        end.
        
        if  RowObject.ano-per-fim = RowObject.ano-per-ini then do:
            if  RowObject.nr-per-fim < RowObject.nr-per-ini then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-periodoano-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Per°odo/Ano" *}
                ASSIGN c-lbl-liter-periodoano-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                         &ErrorNumber="354"
                         &ErrorType="EMS"
                         &ErrorParameters="c-lbl-liter-periodoano-2"}
            end.
        end.

/** Validaá∆o retirada pois configurado ser† tratado no plano mestre **/

        /*         if RowObject.tipo-plano = "PP" and     */
        /*         &IF DEFINED (bf_man_sfc_lc) &THEN      */
        /*             RowObject.log-pv-config            */
        /*         &ELSE                                  */
        /*             substr(RowObject.char-1,1,1) = '1' */
        /*         &ENDIF then do:                        */
        /*             {method/svc/errors/inserr.i        */
        /*                      &ErrorNumber="16233"      */
        /*                      &ErrorType="EMS"          */
        /*                      &ErrorParameters="''"}    */
        /*         end.                                   */
        
        &IF DEFINED(bf_man_203) &THEN
            if RowObject.log-multi-estabel = yes then do:
               find first pl-it-prod 
                    where pl-it-prod.cd-plano    = RowObject.cd-plano
                      and pl-it-prod.cod-estabel = ""
               no-lock no-error.
               if available pl-it-prod then do:                   
                    {method/svc/errors/inserr.i
                             &ErrorNumber="19259"
                             &ErrorType="EMS"
                             &ErrorParameters="''"}
               end.
            end.
            else do:
               find first pl-it-prod 
                    where pl-it-prod.cd-plano = RowObject.cd-plano
                      and pl-it-prod.cod-estabel > ""
               no-lock no-error.
               if available pl-it-prod then do:
                    {method/svc/errors/inserr.i
                             &ErrorNumber="19260"
                             &ErrorType="EMS"
                             &ErrorParameters="''"}
               end.
            end.
        &ENDIF       
    END.
      
    IF pType = "Delete":U THEN DO:
       run deleteRelacionamentos.
    END.
            
  
  /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaItensFora DBOProgram 
PROCEDURE verificaItensFora :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se existe itens fora do per°odo informado
  Parameters:  i - codigo do plano, i - data termino, i - tipo,
               o - itens fora
  Notes:       tipo = Verifica faixa com maior ou menor a data informada
               l-it-fora = informa se encontrou itens fora da faixa
------------------------------------------------------------------------------*/
def input param i-cod-plano as int.
def input param da-data     as date.
def input param i-tipo      as int.
def output param l-it-fora  as log.

if i-tipo = 1 then do:
  find first pl-it-prod
       where pl-it-prod.cd-plano   = i-cod-plano
       and   pl-it-prod.dt-termino < da-data no-lock no-error.
  if avail pl-it-prod then 
     assign l-it-fora = yes.
end.
else do:  
  find last  pl-it-prod
       where pl-it-prod.cd-plano   = i-cod-plano
       and   pl-it-prod.dt-termino > da-data no-lock no-error.
  if avail pl-it-prod then 
     assign l-it-fora = yes.
end.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaNivelItens DBOProgram 
PROCEDURE verificaNivelItens :
/*------------------------------------------------------------------------------
  Purpose:     Verifica o n°vel mais baixo dos itens do plano
  Parameters:  i - c¢digo do plano, o - n°vel diferente de zero
  Notes:       
------------------------------------------------------------------------------*/
def input  param i-cod-plano as int.
def output param l-confirma  as log.

    nivel:
    for each pl-it-prod use-index codigo
        where pl-it-prod.cd-plano = i-cod-plano NO-LOCK:
        FOR each item use-index codigo
        where item.it-codigo = pl-it-prod.it-codigo no-lock:
            if  item.niv-mais-bai <> 0 then do:
                assign l-confirma = no.
                leave nivel.
            end.
        END.
    end.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaPeriodoItens DBOProgram 
PROCEDURE verificaPeriodoItens :
/*------------------------------------------------------------------------------
  Purpose:     Verifica o per°odo dos itens do plano
  Parameters:  i - c¢digo do plano, i - tipo do per°odo, i - data fim
               o - se n∆o existe per°odo ou a data de tÇrmino est† diferente da informada
  Notes:       
------------------------------------------------------------------------------*/
def input  param i-cod-plano  as int.
def input  param i-cod-tipo   as int.
def input  param dt-fim-per-i as date.
def output param l-todos      as log.

    for each  pl-it-prod 
        where pl-it-prod.cd-plano = i-cod-plano NO-LOCK:
        find periodo use-index codigo where
             periodo.cd-tipo    = i-cod-tipo     and
             periodo.ano        = pl-it-prod.ano and
             periodo.nr-periodo = pl-it-prod.periodo no-lock no-error.
        if  not avail periodo then
            assign l-todos = yes.
        else 
           if avail periodo 
              and   periodo.dt-termino <> dt-fim-per-i then 
              assign l-todos = yes.
    end.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE getRowObjectExtra:
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectExtra.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE afterCopyBuffer2TT:
    CREATE RowObjectExtra.
    ASSIGN RowObjectExtra.r-Rowid = ROWID({&TABLENAME}).

    FOR FIRST bftipo-per FIELDS(tipo descricao) NO-LOCK
        WHERE bftipo-per.cd-tipo = {&TABLENAME}.cd-tipo :

        ASSIGN RowObjectExtra.tipo = bftipo-per.tipo
               RowObjectExtra.desc-tipo = bftipo-per.descricao.
    END.

    FOR FIRST bfperiodo FIELDS(dt-inicio dt-termino) NO-LOCK
        WHERE bfperiodo.ano        = {&TABLENAME}.ano-per-ini
        AND   bfperiodo.nr-periodo = {&TABLENAME}.nr-per-ini
        AND   bfperiodo.cd-tipo    = {&TABLENAME}.cd-tipo:

        ASSIGN RowObjectExtra.dt-inicio-i  = bfperiodo.dt-inicio  
               RowObjectExtra.dt-termino-i = bfperiodo.dt-termino.

    END.

    FOR FIRST bfperiodo FIELDS(dt-inicio dt-termino) NO-LOCK
        WHERE bfperiodo.ano        = {&TABLENAME}.ano-per-fim
        AND   bfperiodo.nr-periodo = {&TABLENAME}.nr-per-fim
        AND   bfperiodo.cd-tipo    = {&TABLENAME}.cd-tipo:

        ASSIGN RowObjectExtra.dt-inicio-f  = bfperiodo.dt-inicio 
               RowObjectExtra.dt-termino-f = bfperiodo.dt-termino.

    END.

    IF INT(SUBSTRING({&TABLENAME}.char-1,11,1)) > 0 THEN
        ASSIGN RowObjectExtra.plan-horiz-fixo = {mfinc/i01mf318.i 04 INT(SUBSTRING({&TABLENAME}.char-1,11,1))}.
    ELSE
        ASSIGN RowObjectExtra.plan-horiz-fixo = {mfinc/i01mf318.i 04 1}.

    IF INT(SUBSTRING({&TABLENAME}.char-1,12,1)) > 0 THEN
        ASSIGN RowObjectExtra.demanda-comp = {mfinc/i02mf318.i 04 INT(SUBSTRING({&TABLENAME}.char-1,12,1))}.
    ELSE
        ASSIGN RowObjectExtra.demanda-comp = {mfinc/i02mf318.i 04 1}.

    IF  INT(SUBSTRING({&TABLENAME}.char-1,13,1)) > 0 THEN
        ASSIGN RowObjectExtra.demanda-fabr = {mfinc/i02mf318.i 04 INT(SUBSTRING({&TABLENAME}.char-1,13,1))}.
    ELSE
        ASSIGN RowObjectExtra.demanda-fabr = {mfinc/i02mf318.i 04 1}.

    ASSIGN RowObjectExtra.rem-con-comp = NOT(SUBSTR({&TABLENAME}.char-1,4,1) = "2")
           RowObjectExtra.ent-con-comp = NOT(SUBSTR({&TABLENAME}.char-1,5,1) = "2")
           RowObjectExtra.rem-ben-comp = NOT(SUBSTR({&TABLENAME}.char-1,2,1) = "2")
           RowObjectExtra.ent-ben-comp = NOT(SUBSTR({&TABLENAME}.char-1,3,1) = "2")    
           RowObjectExtra.rem-ben-fab  = NOT(SUBSTR({&TABLENAME}.char-1,6,1) = "2")
           RowObjectExtra.ent-ben-fab  = NOT(SUBSTR({&TABLENAME}.char-1,7,1) = "2")
           RowObjectExtra.rem-con-fab  = NOT(SUBSTR({&TABLENAME}.char-1,8,1) = "2")
           RowObjectExtra.ent-con-fab  = NOT(SUBSTR({&TABLENAME}.char-1,9,1) = "2")
           RowObjectExtra.rep-oc-and   = (SUBSTR(STRING({&TABLENAME}.int-1),1,1) = "1")
           RowObjectExtra.rep-op-and   = (SUBSTR(STRING({&TABLENAME}.int-1),2,1) = "1")
           RowObjectExtra.tp-rep-comp  = {ininc/i06in122.i 04 {&TABLENAME}.tp-rep-comp}
           RowObjectExtra.tp-rep-fabr  = {ininc/i06in122.i 04 {&TABLENAME}.tp-rep-fabr}.

    RETURN "OK":U.
    
END PROCEDURE.



PROCEDURE atualizaPeriodoItens.
def input param i-cod-plano as int.
def input param i-cd-tipo   as int.
def input param da-data-ini as date.
def input param da-data-fim as date.

DEFINE BUFFER bfpl-it-prod FOR pl-it-prod.

for each  pl-it-prod 
    where pl-it-prod.cd-plano = i-cod-plano
    and  (pl-it-prod.dt-termino >= da-data-ini 
    or    pl-it-prod.dt-termino <= da-data-fim) EXCLUSIVE-LOCK:
    
    FOR FIRST bfperiodo FIELDS(dt-inicio dt-termino ano nr-periodo) NO-LOCK                             
        WHERE bfperiodo.cd-tipo    = i-cd-tipo
          AND bfperiodo.dt-inicio  <= pl-it-prod.dt-termino
          AND bfperiodo.dt-termino >= pl-it-prod.dt-termino:

        IF bfperiodo.ano        <> pl-it-prod.ano     OR
           bfperiodo.nr-periodo <> pl-it-prod.periodo THEN DO:
                                                                                         
            FIND FIRST bfpl-it-prod EXCLUSIVE-LOCK
                WHERE bfpl-it-prod.cd-plano      = pl-it-prod.cd-plano
                  AND bfpl-it-prod.cod-estabel   = pl-it-prod.cod-estabel 
                  AND bfpl-it-prod.it-codigo     = pl-it-prod.it-codigo   
                  AND bfpl-it-prod.cod-refer     = pl-it-prod.cod-refer   
                  AND bfpl-it-prod.ano           = bfperiodo.ano         
                  AND bfpl-it-prod.periodo       = bfperiodo.nr-periodo     
                  AND bfpl-it-prod.nome-abrev    = pl-it-prod.nome-abrev  
                  AND bfpl-it-prod.nr-pedcli     = pl-it-prod.nr-pedcli   
                  AND bfpl-it-prod.nr-sequencia  = pl-it-prod.nr-sequencia
                  AND bfpl-it-prod.cod-gr-cli    = pl-it-prod.cod-gr-cli   NO-ERROR.
            IF NOT AVAILABLE bfpl-it-prod THEN DO:
                ASSIGN pl-it-prod.ano     = bfperiodo.ano       
                       pl-it-prod.periodo = bfperiodo.nr-periodo   .
            END.
            ELSE DO:
                ASSIGN bfpl-it-prod.quantidade = bfpl-it-prod.quantidade + pl-it-prod.quantidade 
                       bfpl-it-prod.qt-confirm = bfpl-it-prod.qt-confirm + pl-it-prod.qt-confirm.

                DELETE pl-it-prod.
            END.

            FIND CURRENT bfpl-it-prod NO-LOCK NO-ERROR.
        END.

    END.

end.



END PROCEDURE.

