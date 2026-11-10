/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9004A 2.00.00.011 } /*** "010011" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9004a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9004a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Teste para o programa de Requisicao de Materiais (bcp/bc9004.p)           **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-requis-mat-bc.tipo-trans ~
                            tt-requis-mat-bc.cod-depos ~
                            tt-requis-mat-bc.cod-estabel ~
                            tt-requis-mat-bc.cod-refer ~
                            tt-requis-mat-bc.ct-codigo ~
                            tt-requis-mat-bc.it-codigo ~
                            tt-requis-mat-bc.item-pai ~
                            tt-requis-mat-bc.cod-localiz ~
                            tt-requis-mat-bc.lote ~
                            tt-requis-mat-bc.nro-docto ~
                            tt-requis-mat-bc.nr-ord-produ ~
                            tt-requis-mat-bc.quantidade ~
                            tt-requis-mat-bc.sc-codigo ~
                            tt-requis-mat-bc.un ~
                            tt-requis-mat-bc.op-codigo ~
                            tt-requis-mat-bc.op-seq ~
                            tt-requis-mat-bc.cod-roteiro ~
                            tt-requis-mat-bc.dt-vali-lote ~
                            tt-requis-mat-bc.data-transacao ~
                            tt-requis-mat-bc.cod-unico ~
                            tt-requis-mat-bc.cod-usuario ~
                            tt-requis-mat-bc.dt-nf-saida


/********************  Frame tt-requis-mat-bcs Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9004.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramTitle Requisi‡Æo de Materiais - bc9004a.p 2.00.00.000
/*******************  Program Title Preprocessor Definitions End  ***************/
                           
                           
/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9004
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-requis-mat-bc
/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                           " Doc: "        + String({&Table}.nro-docto)     + ~
                           " Item: "       + Trim(  {&table}.it-codigo)     + ~
                           " Ref: "        + Trim(  {&Table}.cod-refer)     + ~
                           " Depos: "      + Trim(  {&Table}.cod-depos)     + ~
                           " Local: "      + Trim(  {&Table}.cod-localiz)     + ~
                           " Lote: "       + Trim(  {&Table}.lote)          + ~
                           " Qt: "         + String({&Table}.quantidade)

/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
