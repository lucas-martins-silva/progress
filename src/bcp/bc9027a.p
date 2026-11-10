/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9027A 2.00.00.004} /*** "010004" 21/03/2024 09:45:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9027a MBC}
&ENDIF

{include/i_dbinst.i}  /* vers’o das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9027a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Mar/2005 - Frank Rinald Rodrigues                           **
**                                                                                         **
**   Objetivo..: Manuten‡Æo - montagem de pallet wms                                       **
**                                                                                         **
**   Includes..: bcp/bc9127.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-Montagem-Pallet.id-agrupador   ~
                            tt-Montagem-Pallet.id-etiqueta    ~
                            tt-Montagem-Pallet.it-codigo      ~
                            tt-Montagem-Pallet.qtd-item       ~
                            tt-Montagem-Pallet.qtd-peso

/********************  Frame Fields Preprocessor Definitions End  ***************/
/*****************  Name of TT Include Preprocessor Definitions Beg  ************/

&GLOBAL-DEFINE NameOfTTInclude bcp/bc9027.i

/*****************  Name of TT Include Preprocessor Definitions End  ************/
/*******************  Program Title Preprocessor Definitions Beg  ***************/

&GLOBAL-DEFINE ProgramBC9027A

/*******************  Program Title Preprocessor Definitions End  ***************/
/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2

/**************  Frame Number of Columns Preprocessor Definitions End  **********/
/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/

&GLOBAL-DEFINE TransactionProgram bc9027

/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-Montagem-Pallet

/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                           " It: "        + String({&table}.it-codigo)     + ~
                           " Agrup: "        + String({&table}.id-agrupador)     + ~
                           " Etiq: "       + STRING(  {&table}.id-etiqueta)     + ~
                           " Qt item: "       + STRING(  {&Table}.qtd-item)    + ~
                           " Qt peso: "       + STRING(  {&Table}.qtd-peso)


/**********************  Table Preprocessor Definitions End  ********************/

/**************  Fields Custom Display Preprocessor Definitions Beg  ************/

/*&GLOBAL-DEFINE CustomDisplayField01 tt-transfere-bc.data-transacao
&GLOBAL-DEFINE CustomValueField01   String(today,'99/99/9999')*/

/**************  Fields Custom Display Preprocessor Definitions End  ************/
/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/
/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
