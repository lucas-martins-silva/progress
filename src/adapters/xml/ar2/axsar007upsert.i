PROCEDURE PITransUpsert:

define input parameter r-rowid  as rowid   no-undo.
define output parameter table for tt_log_erro.

DEFINE VARIABLE i-cont AS INTEGER    NO-UNDO.

FIND FIRST param-estoq NO-LOCK NO-ERROR.

FIND FIRST item-estab
    WHERE rowid(item-estab) = r-rowid NO-LOCK NO-ERROR.
IF AVAIL item-estab THEN DO:

    CREATE ttListOfItemBalances.
    ASSIGN ttListOfItemBalances.SiteID = item-estab.cod-estabel.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = item-estab.cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN ttListOfItemBalances.SiteDescription = estabelec.nome.


    DO i-cont = 1 TO 3:
        
        IF i-cont = 1 THEN DO:

            CREATE ttInitialValues.

            FIND FIRST moeda
                WHERE moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttInitialValues.CurrencyDescription  = moeda.descricao
                       ttInitialValues.CurrencySign         = sigla.

                ASSIGN ttInitialValues.InitialLaborValue    = item-estab.sald-ini-mob-m[i-cont]
                       ttInitialValues.InitialMaterialValue = item-estab.sald-ini-mat-m[i-cont]
                       ttInitialValues.InitialOverHeadValue = item-estab.sald-ini-ggf-m[i-cont]
                       ttInitialValues.IsDefaultCurrency    = YES.

        END.
        ELSE IF  i-cont = 2
             AND param-estoq.tem-moeda1 THEN DO:

            CREATE ttInitialValues.

            FIND FIRST moeda
                WHERE moeda.mo-codigo = param-estoq.moeda1 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttInitialValues.CurrencyDescription  = moeda.descricao
                       ttInitialValues.CurrencySign         = sigla.

                ASSIGN ttInitialValues.InitialLaborValue    = item-estab.sald-ini-mob-m[i-cont]
                       ttInitialValues.InitialMaterialValue = item-estab.sald-ini-mat-m[i-cont]
                       ttInitialValues.InitialOverHeadValue = item-estab.sald-ini-ggf-m[i-cont]
                       ttInitialValues.IsDefaultCurrency    = NO.
        END.
        ELSE IF  i-cont = 3
             AND param-estoq.tem-moeda2 THEN DO:

            CREATE ttInitialValues.

            FIND FIRST moeda
                WHERE moeda.mo-codigo = param-estoq.moeda1 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttInitialValues.CurrencyDescription  = moeda.descricao
                       ttInitialValues.CurrencySign         = sigla.

                ASSIGN ttInitialValues.InitialLaborValue    = item-estab.sald-ini-mob-m[i-cont]
                       ttInitialValues.InitialMaterialValue = item-estab.sald-ini-mat-m[i-cont]
                       ttInitialValues.InitialOverHeadValue = item-estab.sald-ini-ggf-m[i-cont]
                       ttInitialValues.IsDefaultCurrency    = NO.


        END.
    END.
END.

FOR EACH saldo-estoq
    WHERE saldo-estoq.cod-estabel = item-estab.cod-estabel
    AND   saldo-estoq.it-codigo   = item-estab.it-codigo NO-LOCK.

    ASSIGN de-quant-ini = de-quant-ini + saldo-estoq.qtidade-ini .

END.

FIND FIRST ITEM
    WHERE ITEM.it-codigo = item-estab.it-codigo NO-LOCK NO-ERROR.
                          

RUN PIUpsert (input today,  
              INPUT "",
              INPUT "UPD",
              INPUT item-estab.it-codigo,
              INPUT ITEM.desc-item,
              INPUT Param-estoq.ult-fech-dia,  
              OUTPUT TABLE tt_log_erro,
              INPUT TABLE ttInitialValues,
              INPUT TABLE ttListOfItemBalances,
              INPUT ITEM.un,
              INPUT Item-estab.qtidade-atu,
              INPUT de-quant-ini).

END PROCEDURE.
                          



