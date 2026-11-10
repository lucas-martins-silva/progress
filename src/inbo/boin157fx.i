
    
IF ttVarianceParameter.noVariance 
   AND (TRUNCATE(((ttVariance.{1} - ttVariance.{2}) * 100 / IF ttVariance.{2} <> 0 THEN ttVariance.{2} ELSE 1),0) = 0
   OR TRUNCATE(((ttVariance.{1} - ttVariance.{2}) * 100 / IF ttVariance.{2} <> 0 THEN ttVariance.{2} ELSE 1),0) = ?) THEN DO:
   
   FOR FIRST ttInterval
       WHERE ttInterval.initialInterval = 0 EXCLUSIVE-LOCK:
       ASSIGN ttInterval.quantity = ttInterval.quantity + 1.
   END.
END.
ELSE DO:
   IF TRUNCATE(((ttVariance.{1} - ttVariance.{2}) * 100 / IF ttVariance.{2} <> 0 THEN ttVariance.{2} ELSE 1),0) < 0 THEN DO:
       FOR FIRST ttInterval
           WHERE ttInterval.initialInterval = -1
           AND   ttInterval.finalInterval = -1 EXCLUSIVE-LOCK:
           ASSIGN ttInterval.quantity = ttInterval.quantity + 1.
       END.
       IF NOT AVAIL ttInterval THEN DO:
           CREATE ttInterval.
           ASSIGN ttInterval.initialInterval = -1
                  ttInterval.finalInterval = -1
                  ttInterval.quantity = 1.
       END.
   END.
   ELSE IF TRUNCATE(((ttVariance.{1} - ttVariance.{2}) * 100 / IF ttVariance.{2} <> 0 THEN ttVariance.{2} ELSE 1),0) > ttVarianceParameter.finalVariance THEN DO:
       
       FOR FIRST ttInterval
           WHERE ttInterval.finalInterval = ttVarianceParameter.finalVariance + 1 EXCLUSIVE-LOCK:
           ASSIGN ttInterval.quantity = ttInterval.quantity + 1.
       END.
       IF NOT AVAIL ttInterval THEN DO:
           CREATE ttInterval.
           ASSIGN ttInterval.initialInterval = ttVarianceParameter.finalVariance + 1
                  ttInterval.finalInterval = ttVarianceParameter.finalVariance + 1
                  ttInterval.quantity = 1.
       END.
   END.
   ELSE DO:
       FOR FIRST ttInterval
           WHERE ttInterval.initialInterval < TRUNCATE(((ttVariance.{1} - ttVariance.{2}) * 100 / IF ttVariance.{2} <> 0 THEN ttVariance.{2} ELSE 1),0)
           AND   ttInterval.finalInterval >= TRUNCATE(((ttVariance.{1} - ttVariance.{2}) * 100 / IF ttVariance.{2} <> 0 THEN ttVariance.{2} ELSE 1),0) EXCLUSIVE-LOCK:
           ASSIGN ttInterval.quantity = ttInterval.quantity + 1.
       END.
   END.
END.
