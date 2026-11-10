/*------------------------------------------------------------------------------
  Purpose: Verificar se a versão do exame que está sendo percorrido está liberada
  Parameters:  {1} => <TABLE>.cod-exame
  Notes:
------------------------------------------------------------------------------*/
IF NOT CAN-FIND(FIRST exame 
                WHERE exame.cod-exame    = {1}
                  AND exame.cdn-sit-vers = 2 /*Liberada */ ) THEN NEXT.