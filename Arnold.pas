unit Arnold;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Global;

type
  TFormArnold = class(TForm)
    LNegativo: TLabel;
    BtAbrirImagem: TButton;
    OpenDialogImage: TOpenDialog;
    Label1: TLabel;
    BtAplicarTransformacao: TButton;
    GroupBox1: TGroupBox;
    Imagem1: TImage;
    GroupBox2: TGroupBox;
    Imagem2: TImage;
    procedure BtAplicarTransformacaoClick(Sender: TObject);
    procedure BtAbrirImagemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormArnold: TFormArnold;
  ImagemPGM1: ImagemPGM;
  ImagemPGM2: ImagemPGM;
implementation

{$R *.dfm}

procedure TFormArnold.BtAbrirImagemClick(Sender: TObject);
begin
  if OpenDialogImage.Execute
  then
  begin
    ImagemPGM1 := AbrirImagem(OpenDialogImage.FileName);
    LimparImagem(Imagem1);
    LimparImagem(Imagem2);
    DesenharImagem(ImagemPGM1, Imagem1);

    // Copiando a Imagem1 na Imagem2
    ImagemPGM2 := ImagemPGM1;
  end;
end;

procedure TFormArnold.BtAplicarTransformacaoClick(Sender: TObject);
begin
  // Aplicando o Filtro de Arnold
  ImagemPGM2 := AplicarArnold(ImagemPGM2);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM2, Imagem2);
end;

end.
