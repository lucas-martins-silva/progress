FUNCTION fn_data_vencto_pis_cofins_csll RETURN DATE (INPUT vEmpresa AS INT, INPUT vEstab AS CHAR, INPUT vDataBaixa AS DATE):

    DEF VAR vDataVencto AS DATE.

    ASSIGN vDataVencto = IF DAY(vDataBaixa) > 15 THEN
                            IF MONTH(vDataBaixa) = 12 THEN
                               DATE(01,01,YEAR(vDataBaixa) + 1)
                            ELSE
                               DATE(MONTH(vDataBaixa) + 1,01,YEAR(vDataBaixa))
                         ELSE
                            DATE(MONTH(vDataBaixa),16,YEAR(vDataBaixa)).

    FIND FIRST calen-coml NO-LOCK
        WHERE calen-coml.ep-codigo    = vEmpresa
          AND calen-coml.cod-estabel  = vEstab
          AND calen-coml.data        >= vDataVencto
          AND calen-coml.tipo         = 2 NO-ERROR.
    IF AVAIL calen-coml THEN DO:
        ASSIGN vDataVencto = calen-coml.data + 7.

        FIND LAST calen-coml NO-LOCK
            WHERE calen-coml.ep-codigo   = vEmpresa
              AND calen-coml.cod-estabel = vEstab
              AND calen-coml.data        < vDataVencto
              AND calen-coml.tipo        = 1 NO-ERROR.
        IF AVAIL calen-coml THEN
            ASSIGN vDataVencto = calen-coml.data.
    END.

    RETURN vDataVencto.

END FUNCTION.
