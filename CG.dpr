program CG;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  Sobre in 'Sobre.pas' {FormSobre},
  Global in 'Global.pas',
  Negativo in 'Negativo.pas' {FormNegativo},
  Filtros in 'Filtros.pas' {FormFiltros},
  Operacoes in 'Operacoes.pas' {FormOperacoes},
  Arnold in 'Arnold.pas' {FormArnold},
  Gamma in 'Gamma.pas' {FormGamma},
  Histograma in 'Histograma.pas' {FormHistograma},
  Pseudocor in 'Pseudocor.pas' {FormPseudocor};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormSobre, FormSobre);
  Application.CreateForm(TFormNegativo, FormNegativo);
  Application.CreateForm(TFormFiltros, FormFiltros);
  Application.CreateForm(TFormOperacoes, FormOperacoes);
  Application.CreateForm(TFormArnold, FormArnold);
  Application.CreateForm(TFormGamma, FormGamma);
  Application.CreateForm(TFormHistograma, FormHistograma);
  Application.CreateForm(TFormPseudocor, FormPseudocor);
  Application.Run;
end.
