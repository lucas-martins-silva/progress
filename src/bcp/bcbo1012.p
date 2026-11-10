/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCBO1012 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcbo1012 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: BCBO1012.p
**
**   VersÆo....: 02.00.00 - Datasul
**
**   Objetivo..: BO de Acesso a tabela Ord-prod do datasul-EMS 2 para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/***********************  General Preprocessor Definitions Beg  ******************/
&GLOBAL-DEFINE Table Ord-prod
&GLOBAL-DEFINE ProductName datasul-EMS
&GLOBAL-DEFINE LocalNumber 3 /** datasul-EMS 2 **/
/***********************  General Preprocessor Definitions End  ******************/


/********************************  Includes Beg  ********************************/
{bcp/bc8112.i} /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/


/****************  CreateOutputRecord Preprocessor Definitions Beg  **************/

/****************  CreateOutputRecord Preprocessor Definitions End  **************/


/*******************  FindRecord Preprocessor Definitions Beg  *******************/
&GLOBAL-DEFINE FindKeyPhrase ~
                Where {&Table}.nr-ord-produ    = ttParam{&Table}.nr-ord-produ-ini
/*******************  FindRecord Preprocessor Definitions Beg  *******************/


/******************  ForEachRecord Preprocessor Definitions Beg  *****************/
&SCOPED-DEFINE NumRecords ~
    if  ttParam{&Table}.acess-mode = 6 then do: ~
        Assign vRec = vRec + 1. ~
        If vRec > ttParam{&Table}.num-of-rec then leave. ~
    End.
/* record-phrase = 1 */
&GLOBAL-DEFINE RecordPhrase01          YES              /* Determina que existe for each para record-phrase 1 */
&GLOBAL-DEFINE EachRecordPhrase01 ~
            If   ttParam{&Table}.nr-ord-produ-ini = ttParam{&Table}.nr-ord-produ-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.nr-ord-produ = ttParam{&Table}.nr-ord-produ-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.nr-ord-produ-ini <> ttParam{&Table}.nr-ord-produ-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.nr-ord-produ >= ttParam{&Table}.nr-ord-produ-ini ~
                    And   {&Table}.nr-ord-produ <= ttParam{&Table}.nr-ord-produ-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ 

/* record-phrase = 2 */
&GLOBAL-DEFINE RecordPhrase02          YES              /* Determina que existe for each para record-phrase 2 */
&GLOBAL-DEFINE EachRecordPhrase02 ~
            If   ttParam{&Table}.it-codigo-ini = ttParam{&table}.it-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.it-codigo = ttParam{&table}.it-codigo-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.it-codigo-ini <> ttParam{&table}.it-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.it-codigo >= ttParam{&table}.it-codigo-ini ~
                    And   {&Table}.it-codigo <= ttParam{&table}.it-codigo-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ 

/* record-phrase = 3 */
&GLOBAL-DEFINE RecordPhrase03          YES              /* Determina que existe for each para record-phrase 3 */
&GLOBAL-DEFINE EachRecordPhrase03 ~
            If   ttParam{&Table}.cod-estabel-ini = ttParam{&Table}.cod-estabel-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.cod-estabel = ttParam{&Table}.cod-estabel-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.cod-estabel-ini <> ttParam{&Table}.cod-estabel-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.cod-estabel >= ttParam{&Table}.cod-estabel-ini ~
                    And   {&Table}.cod-estabel <= ttParam{&Table}.cod-estabel-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 4 */
&GLOBAL-DEFINE RecordPhrase04          YES              /* Determina que existe for each para record-phrase 4 */
&GLOBAL-DEFINE EachRecordPhrase04 ~
            If   ttParam{&Table}.cod-depos-ini = ttParam{&Table}.cod-depos-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.cod-depos = ttParam{&Table}.cod-depos-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.cod-depos-ini <> ttParam{&Table}.cod-depos-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.cod-depos >= ttParam{&Table}.cod-depos-ini ~
                    And   {&Table}.cod-depos <= ttParam{&Table}.cod-depos-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/******************  ForEachRecord Preprocessor Definitions End  *****************/


/*********************************  Program Beg *********************************/
{bcp/bcbo.i}
/*********************************  Program End *********************************/

  
