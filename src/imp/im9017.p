/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9017 2.00.00.023 } /*** "010023" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9017 MIM}
&ENDIF

/*****************************************************************************
**
** IM9017 - Integra‡Æo entre os m¢dulos Caixa e Bancos e Importa‡Æo. (EMS 5.0)
**
** Objetivo: Gerar fluxo de caixa das despesas da importa‡Æo.
**
******************************************************************************/
{cdp/cdcfgmat.i} /* Pre-processador */
{cdp/cdcfgdis.i}
{include/i-epc200.i}

/* Variavel criada para controlar execucao gerencial */
def new global shared var gl-fluxo-gerencial as logical init no no-undo.

def new shared var        l-consid-prev-pgto as logical.

{cbp/cbapi001.i}
{ccp/ccapi011.i} /* Defini‡Æo tt-movto-fluxo */
{cdp/cd1204.i}   /*tt-param*/
{imp/im9040.i}   /* tt-despesas-importacao */
{cdp/cd9590.i}    /*include verifica‡Æo Unidade Neg¢cio*/

def input        parameter rw-ordem-compra as ROWID NO-UNDO.
def input        parameter rw-prazo-compra as ROWID  NO-UNDO.
def input        parameter table for tt-param-fluxo.
def input-output parameter table for tt-movto-fluxo.
def input-output parameter table for tt-despesas-importacao.
def output       parameter table for tt-erro.

def var l-imp    as logical initial yes no-undo.
   
{imp/im9008.i}

run gera-fluxo-caixa-im9017.      

{ccp/ccapi011.i2}    /** Procedures internas **/    
