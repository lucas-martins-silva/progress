PROCEDURE PITransDelete:
    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAMETER InitialDate_00 AS DATE INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM InitialTime_00 AS CHARACTER INITIAL ? NO-UNDO.  /*Hor rio inicial do bloqueio (Uso interno: Campo = bloq-movto-item-depos.hra-inic-bloq)*/
    DEFINE INPUT PARAM ItemCode_00 AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do item. (Uso interno: Campo = bloq-movto-item-depos.it-codigo)*/
    DEFINE INPUT PARAM SiteID_00 AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do estabelecimento. (Uso interno: Campo = bloq-movto-item-depos.cod-estabel)*/
    DEFINE INPUT PARAM WarehouseID_00 AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo dep¢sito. (Uso interno: Campo = bloq-movto-item-depos.cod-depos)*/
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/
    
    /*LOCAL VARIABLES - BEGIN*/
    DEFINE VARIABLE ItemDescription_00 AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VARIABLE SiteDescription_00 AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VARIABLE WarehouseDescription_00 AS CHARACTER INITIAL ? NO-UNDO.
    /*LOCAL VARIABLES - END*/
        
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    FIND FIRST ITEM 
         WHERE ITEM.it-codigo = ItemCode_00 NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN
        ASSIGN ItemDescription_00 = ITEM.desc-item.
    
    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = SiteID_00 NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN SiteDescription_00 = estabelec.nome.
    
    FIND FIRST deposito
         WHERE deposito.cod-depos = WarehouseID_00 NO-LOCK NO-ERROR.
    IF AVAIL deposito THEN
        ASSIGN WarehouseDescription_00 = deposito.nome.

     RUN PIDelete
     (
          INPUT "",
          INPUT "del":U,
          INPUT InitialDate_00,
          INPUT InitialTime_00,
          INPUT ItemCode_00,
          INPUT ItemDescription_00,
          INPUT SiteDescription_00,
          INPUT SiteID_00,
          OUTPUT TABLE tt_log_erro,
          INPUT WarehouseDescription_00,
          INPUT WarehouseID_00
      ).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.
