/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9006A 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9006a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9006a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Teste para o programa de Reporte Repetitivo (bcp/bc9006.p)                **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-reporte-repet-bc.data ~
                            tt-reporte-repet-bc.nr-reporte ~
                            tt-reporte-repet-bc.qt-reporte ~
                            tt-reporte-repet-bc.qt-refugo ~
                            tt-reporte-repet-bc.qt-estorno ~
                            tt-reporte-repet-bc.cod-usuario ~
                            tt-reporte-repet-bc.hora ~
                            tt-reporte-repet-bc.it-codigo ~
                            tt-reporte-repet-bc.ct-refugo ~
                            tt-reporte-repet-bc.sc-refugo ~
                            tt-reporte-repet-bc.qt-apr-cond ~
                            tt-reporte-repet-bc.nro-docto ~
                            tt-reporte-repet-bc.serie-docto ~
                            tt-reporte-repet-bc.cod-depos ~
                            tt-reporte-repet-bc.lote-serie ~
                            tt-reporte-repet-bc.cod-refer ~
                            tt-reporte-repet-bc.dt-vali-lote ~
                            tt-reporte-repet-bc.cod-localiz ~
                            tt-reporte-repet-bc.cod-estabel ~
                            tt-reporte-repet-bc.cod-cta-aplic ~
                            tt-reporte-repet-bc.cod-ccusto-aplic ~
                            tt-reporte-repet-bc.qt-est-aprov ~
                            tt-reporte-repet-bc.qt-est-refugo ~
                            tt-reporte-repet-bc.cod-local-sai ~
                            tt-reporte-repet-bc.cod-depos-sai ~
                            tt-reporte-repet-bc.loc-sai-unica ~
                            tt-reporte-repet-bc.data-transacao ~
                            tt-reporte-repet-bc.cod-unico ~
                            tt-reporte-repet-bc.cod-livre-1 ~
                            tt-reporte-repet-bc.cod-livre-2 ~
                            tt-reporte-repet-bc.cod-livre-3 ~
                            tt-reporte-repet-bc.num-livre-1 ~
                            tt-reporte-repet-bc.num-livre-2 ~
                            tt-reporte-repet-bc.num-livre-3 ~
                            tt-reporte-repet-bc.dec-livre-1 ~
                            tt-reporte-repet-bc.dec-livre-2 ~
                            tt-reporte-repet-bc.dec-livre-3 ~
                            tt-reporte-repet-bc.log-livre-1 ~
                            tt-reporte-repet-bc.log-livre-2 ~
                            tt-reporte-repet-bc.log-livre-3 ~
                            tt-reporte-repet-bc.dat-livre-1 ~
                            tt-reporte-repet-bc.dat-livre-2 ~
                            tt-reporte-repet-bc.dat-livre-3 ~

/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9006.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramTitle Transferencia - bc9006a.p 2.00.00.000
/*******************  Program Title Preprocessor Definitions End  ***************/
                           
                           
/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 3
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9006
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-reporte-repet-bc
/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                           " Doc: "        + String({&Table}.nro-docto)         + ~
                           " Item: "       + Trim(  {&table}.it-codigo)         + ~
                           " Ref: "        + Trim(  {&Table}.cod-refer)         + ~
                           " Depos: "      + Trim(  {&Table}.cod-depos-sai)     + ~
                           " Local: "      + Trim(  {&Table}.cod-local-sai)     + ~
                           " Lote: "       + Trim(  {&Table}.lote-serie)        + ~
                           " Qt: "         + String({&Table}.qt-reporte)

/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
