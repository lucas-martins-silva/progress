//af-periodo-aval.dt-periodo-ini
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "PeriodoInicial"
    myParam:svDisplayName = "Per¡odo Inicial"
    myParam:svType        = "Date"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-periodo-aval.dt-periodo-fim
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "PeriodoFinal"
    myParam:svDisplayName = "Per¡odo Final"
    myParam:svType        = "Date"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-contr-indice.cod-estabel
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "CodigoEstabelecimentoIni"
    myParam:svDisplayName = "Estabelecimento inicial"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-contr-indice.cod-estabel
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "CodigoEstabelecimentoFim"
    myParam:svDisplayName = "Estabelecimento final"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-contr-indice.cod-emitente
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "CodigoFornecedorIni"
    myParam:svDisplayName = "Fornecedor inicial"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-contr-indice.cod-emitente
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "CodigoFornecedorFim"
    myParam:svDisplayName = "Fornecedor final"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-contr-indice.it-codigo
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "ItemInicial"
    myParam:svDisplayName = "Item inicial"
    myParam:svType        = "Character"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-contr-indice.it-codigo
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "ItemFinal"
    myParam:svDisplayName = "Item final"
    myParam:svType        = "Character"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-contr-indice.nr-controle
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "NumeroControleIni"
    myParam:svDisplayName = "N£mero Controle inicial"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-contr-indice.nr-controle
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "NumeroControleFim"
    myParam:svDisplayName = "N£mero Controle final"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-grp-avaliacao-form.cod-grp-avaliacao
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "GrupoAvaliacaoIni"
    myParam:svDisplayName = "Grupo Avalia‡Æo inicial"
    myParam:svType        = "Character"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-grp-avaliacao-form.cod-grp-avaliacao
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "GrupoAvaliacaoFim"
    myParam:svDisplayName = "Grupo Avalia‡Æo final"
    myParam:svType        = "Character"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-item-contr-estab-form.cod-grp-resp
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "GrupoResponsavelIni"
    myParam:svDisplayName = "Grupo Respons vel inicial"
    myParam:svType        = "Character"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//af-item-contr-estab-form.cod-grp-resp
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "GrupoResponsavelFim"
    myParam:svDisplayName = "Grupo Respons vel final"
    myParam:svType        = "Character"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//emitente.cod-gr-forn
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "GrupoFornecedorIni"
    myParam:svDisplayName = "Grupo Fornecedor inicial"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//emitente.cod-gr-forn
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "GrupoFornecedorFim"
    myParam:svDisplayName = "Grupo Fornecedor final"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//item.fm-codigo
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "CodigoFamilia"
    myParam:svDisplayName = "Fam¡lia"
    myParam:svType        = "Character"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).

//item.ge-codigo
ASSIGN 
	myParam               = NEW schemaParameter()
    myParam:svName        = "GrupoEstoque"
    myParam:svDisplayName = "Grupo Estoque"
    myParam:svType        = "Integer"
    myParam:svMultiValue  = NO.
RUN addSchemaParameter (myParam).