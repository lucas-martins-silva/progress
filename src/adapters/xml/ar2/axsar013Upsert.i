PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER InitialDate AS DATE INITIAL ? NO-UNDO.
DEFINE INPUT PARAM InitialTime AS CHARACTER INITIAL ? NO-UNDO.  /*Hor rio inicial do bloqueio (Uso interno: Campo = bloq-movto-item-depos.hra-inic-bloq)*/
DEFINE INPUT PARAM ItemCode AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do item. (Uso interno: Campo = bloq-movto-item-depos.it-codigo)*/
DEFINE INPUT PARAM SiteID AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do estabelecimento. (Uso interno: Campo = bloq-movto-item-depos.cod-estabel)*/
DEFINE INPUT PARAM WarehouseID AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo dep¢sito. (Uso interno: Campo = bloq-movto-item-depos.cod-depos)*/
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
DEFINE VARIABLE ItemDescription AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VARIABLE SiteDescription AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VARIABLE WarehouseDescription AS CHARACTER INITIAL ? NO-UNDO.
/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
FIND FIRST ITEM 
     WHERE ITEM.it-codigo = ItemCode NO-LOCK NO-ERROR.
IF AVAIL ITEM THEN
    ASSIGN ItemDescription = ITEM.desc-item.

FIND FIRST estabelec 
     WHERE estabelec.cod-estabel = SiteID NO-LOCK NO-ERROR.
IF AVAIL estabelec THEN
    ASSIGN SiteDescription = estabelec.nome.

FIND FIRST deposito
     WHERE deposito.cod-depos = WarehouseID NO-LOCK NO-ERROR.
IF AVAIL deposito THEN
    ASSIGN WarehouseDescription = deposito.nome.


     RUN PIUpsert
     (
          INPUT "",
          INPUT "add":U,
          INPUT InitialDate,
          INPUT InitialTime,
          INPUT ItemCode,
          INPUT ItemDescription,
          INPUT SiteDescription,
          INPUT SiteID,
          OUTPUT TABLE tt_log_erro,
          INPUT WarehouseDescription,
          INPUT WarehouseID
      ).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



