/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9008A 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9008a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9008a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Teste para o programa de Aviso de Embarque (bcp/bc9008.p)                 **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-embarque-bc.num-aviso-embarque ~
                            tt-embarque-bc.nr-resumo ~
                            tt-embarque-bc.data-transacao ~
                            tt-embarque-bc.cod-item ~
                            tt-embarque-bc.cod-unico ~
                            tt-embarque-bc.cod-refer ~
                            tt-embarque-bc.cod-depos ~
                            tt-embarque-bc.cod-local ~
                            tt-embarque-bc.cod-lote ~
                            tt-embarque-bc.dat-valid-lote ~
                            tt-embarque-bc.cod-usuario ~
                            tt-embarque-bc.qtd-embarcada ~
                            tt-embarque-bc.cod-livre-1 ~
                            tt-embarque-bc.cod-livre-2 ~
                            tt-embarque-bc.cod-livre-3 ~
                            tt-embarque-bc.num-livre-1 ~
                            tt-embarque-bc.num-livre-2 ~
                            tt-embarque-bc.num-livre-3 ~
                            tt-embarque-bc.dec-livre-1 ~
                            tt-embarque-bc.dec-livre-2 ~
                            tt-embarque-bc.dec-livre-3 ~
                            tt-embarque-bc.log-livre-1 ~
                            tt-embarque-bc.log-livre-2 ~
                            tt-embarque-bc.log-livre-3

/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9008.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramTitle Transferencia - bc9008a.p 2.00.00.000
/*******************  Program Title Preprocessor Definitions End  ***************/
                           
                           
/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9008
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionCode Embarque
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-embarque-bc
/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                          " AvEmb: "       + String({&Table}.num-aviso-embarque) + ~
                          " Res: "         + String({&Table}.nr-resumo)          + ~
                          " Item: "        + Trim(  {&Table}.cod-item)           + ~
                          " Ref: "         + Trim(  {&Table}.cod-refer)          + ~
                          " Depos: "       + Trim(  {&Table}.cod-depos)          + ~
                          " Local: "       + Trim(  {&Table}.cod-local)          + ~
                          " Lote: "        + Trim(  {&Table}.cod-lote)           + ~
                          " Qt: "          + String({&Table}.qtd-embarcada)
/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
