PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/

DEF INPUT PARAM pTranAction       AS CHAR  NO-UNDO . /* add/upd */
DEF INPUT PARAM pPriceTableRowID  AS ROWID NO-UNDO  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE tt_log_erro      NO-ERROR.
EMPTY TEMP-TABLE ttPriceTableItem NO-ERROR.
EMPTY TEMP-TABLE ttPriceUpdate    NO-ERROR.
 
FIND FIRST tb-preco WHERE ROWID(tb-preco) = pPriceTableRowID NO-LOCK NO-ERROR.

IF AVAIL tb-preco THEN DO:

  FOR FIRST moeda FIELDS (descricao sigla)
      WHERE moeda.mo-codigo = tb-preco.mo-codigo NO-LOCK: END.

  FOR FIRST gr-preco FIELDS (descr)
      WHERE gr-preco.cd-gr-preco = tb-preco.cd-gr-preco NO-LOCK: END.

  ASSIGN iContItem    = 0 
         cEvent       = ""       
         cTranAction  = pTranAction

         Comments              = tb-preco.observacoes
         CurrencyID            = tb-preco.mo-codigo 
         DiscountPercentage    = tb-preco.desconto
         InitialValidityDate   = tb-preco.dt-inival
         PriceGroupID          = tb-preco.cd-gr-preco
         PriceTableNumber      = tb-preco.nr-tabpre
         PriceTableDescription = tb-preco.descricao
         ValidityDate          = tb-preco.dt-fimval.
         
      IF tb-preco.situacao >= 1 AND tb-preco.situacao <= 3 THEN
         ASSIGN TableStatus = tb-preco.situacao.

      IF AVAIL moeda THEN 
         ASSIGN CurrencyDescription = moeda.descricao
                CurrencySign        = moeda.sigla.

      IF AVAIL gr-preco THEN
         ASSIGN PriceGroupDescription = gr-preco.descr.

      /* Itens da tabela de pre‡o */
      FOR EACH  preco-item NO-LOCK WHERE preco-item.nr-tabpre = tb-preco.nr-tabpre:

          FOR FIRST ITEM FIELDS (desc-item)
              WHERE ITEM.it-codigo = preco-item.it-codigo NO-LOCK: END.

          FOR FIRST markup FIELDS (cod-formula descricao)
              WHERE markup.cod-markup = preco-item.cod-markup NO-LOCK: END.

          FOR FIRST tab-unidade FIELDS (descricao)
              WHERE tab-unidade.un = preco-item.cod-unid-med NO-LOCK: END. 

          CREATE ttPriceTableItem.
          ASSIGN iContUpd  = 0
                 iContItem = iContItem + 1
                 ttPriceTableItem.ttPriceTableItemID            = iContItem
                 ttPriceTableItem.Sequence                      = iContItem       
                 ttPriceTableItem.CIFSalesPrice                 = preco-item.preco-venda
                 ttPriceTableItem.DiscountPercentageForQuantity = preco-item.desco-quant
                 ttPriceTableItem.FOBSalesPrice                 = preco-item.preco-fob
                 ttPriceTableItem.InitialValidityDate           = preco-item.dt-inival
                 ttPriceTableItem.ItemCode                      = preco-item.it-codigo
                 ttPriceTableItem.ItemReference                 = preco-item.cod-refer
                 ttPriceTableItem.LastUpdateDate                = preco-item.dt-useralt
                 ttPriceTableItem.MarkupID                      = preco-item.cod-markup
                 ttPriceTableItem.MinimumCIFPrice               = preco-item.preco-min-cif
                 ttPriceTableItem.MinimumFOBPrice               = preco-item.preco-min-fob
                 ttPriceTableItem.MinimumQuantity               = preco-item.quant-min
                 ttPriceTableItem.ProfitPercentage              = preco-item.val-pct-lucro
                 ttPriceTableItem.UnitOfMeasureCode             = preco-item.cod-unid-med
                 ttPriceTableItem.ZeroProfitPrice               = preco-item.preco-lucro-zero.
               
              IF preco-item.situacao = 1 OR preco-item.situacao = 2 THEN
                 ASSIGN ttPriceTableItem.PriceTableItemStatus = preco-item.situacao.
              
              IF AVAIL ITEM THEN
                 ASSIGN ttPriceTableItem.ItemDescription = ITEM.desc-item.

              IF AVAIL tab-unidade THEN
                 ASSIGN ttPriceTableItem.UnitOfMeasureDescription =  tab-unidade.descricao.

              IF AVAIL markup THEN DO:
                 FOR FIRST form-tb-formula FIELDS (des-formula dat-inic-validade dat-fim-validad)
                     WHERE form-tb-formula.cod-formula = markup.cod-formula  NO-LOCK: END.

                     ASSIGN ttPriceTableItem.MarkupDescription =  markup.descricao
                            ttPriceTableItem.FormulaID         =  markup.cod-formula.

                IF AVAIL form-tb-formula THEN
                   ASSIGN ttPriceTableItem.FormulaDescription     = form-tb-formula.des-formula
                          ttPriceTableItem.InitialValidityDate_00 = form-tb-formula.dat-inic-validad
                          ttPriceTableItem.ValidityDate           = form-tb-formula.dat-fim-validad.
              END.

              /* Hist¢rico de atualiza‡Æo do item */
              FOR EACH  hist-preco NO-LOCK WHERE hist-preco.nr-tabpre = preco-item.nr-tabpre
                                           AND   hist-preco.it-codigo = preco-item.it-codigo
                                           AND   hist-preco.cod-refer = preco-item.cod-refer
                                           AND   hist-preco.quant-min = preco-item.quant-min :

                  CREATE ttPriceUpdate.
                  ASSIGN iContUpd = iContUpd + 1
                         ttPriceUpdate.ttPriceTableItemID            = iContItem 
                         ttPriceUpdate.Sequence                      = iContUpd 
                         ttPriceUpdate.CIFSalesPrice                 = hist-preco.preco-venda
                         ttPriceUpdate.DiscountPercentageForQuantity = hist-preco.desco-quant
                         ttPriceUpdate.FOBSalesPrice                 = hist-preco.preco-fob
                         ttPriceUpdate.MinimumCIFPrice               = hist-preco.preco-min-cif
                         ttPriceUpdate.MinimumFOBPrice               = hist-preco.preco-min-fob
                         ttPriceUpdate.PriceGroupID                  = hist-preco.cd-gr-preco
                         ttPriceUpdate.UpdateDate                    = hist-preco.dt-movto
                         ttPriceUpdate.UpdateTime                    = hist-preco.hr-movto
                         ttPriceUpdate.UpdateUser                    = hist-preco.usuario-mov
                         ttPriceUpdate.ZeroProfitPrice               = hist-preco.preco-lucro-zero.
                  
                  IF hist-preco.sit-tabpre >= 1 AND hist-preco.sit-tabpre <= 3 THEN
                    ASSIGN ttPriceUpdate.TableStatus = tb-preco.situacao.

                  IF hist-preco.sit-hist = 1 AND hist-preco.sit-hist = 2 THEN
                     ASSIGN ttPriceUpdate.PriceTableItemStatus = hist-preco.sit-hist.

                  IF hist-preco.cd-origem >= 1 AND hist-preco.cd-origem <= 3 THEN
                     ASSIGN ttPriceUpdate.UpdateSource = hist-preco.cd-origem.

                  FOR FIRST gr-preco FIELDS (descr)
                      WHERE gr-preco.cd-gr-preco = hist-preco.cd-gr-preco NO-LOCK: END.

                      IF AVAIL gr-preco THEN
                         ASSIGN ttPriceUpdate.PriceGroupDescription = gr-preco.descr.
                         
              END.  /* hist-preco */
              
     END. /* preco-item */

  RUN PIUpsert ( INPUT cEvent,
                 cTranAction,
                 Comments,
                 CurrencyDescription,
                 CurrencyID,
                 CurrencySign,
                 DiscountPercentage,
                 InitialValidityDate,
                 PriceGroupDescription,
                 PriceGroupID,
                 PriceTableDescription,
                 PriceTableNumber,
                 TableStatus,
                 ValidityDate,
                 INPUT  TABLE ttPriceTableItem,
                 INPUT  TABLE ttPriceUpdate,
                 OUTPUT TABLE tt_log_erro ).

END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.





