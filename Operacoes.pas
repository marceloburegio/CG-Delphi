unit Operacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Global, Menus, OleCtrls, SHDocVw;

type
  TFormOperacoes = class(TForm)
    LNegativo: TLabel;
    BtAbrirImagem1: TButton;
    OpenDialogImagem1: TOpenDialog;
    BtAbrirImagem2: TButton;
    OpenDialogImagem2: TOpenDialog;
    BtSomar: TButton;
    BtSubtrair: TButton;
    BtMultiplicar: TButton;
    BtDividir: TButton;
    BtAND: TButton;
    BtOR: TButton;
    BtXOR: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Imagem1: TImage;
    GroupBox2: TGroupBox;
    Imagem2: TImage;
    GroupBox3: TGroupBox;
    Imagem3: TImage;
    procedure BtXORClick(Sender: TObject);
    procedure BtORClick(Sender: TObject);
    procedure BtANDClick(Sender: TObject);
    procedure BtDividirClick(Sender: TObject);
    procedure BtMultiplicarClick(Sender: TObject);
    procedure BtSubtrairClick(Sender: TObject);
    procedure BtSomarClick(Sender: TObject);
    procedure BtAbrirImagem2Click(Sender: TObject);
    procedure BtAbrirImagem1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOperacoes: TFormOperacoes;
  ImagemPGM1: ImagemPGM;
  ImagemPGM2: ImagemPGM;

implementation

{$R *.dfm}

procedure TFormOperacoes.BtAbrirImagem1Click(Sender: TObject);
begin
  if OpenDialogImagem1.Execute
  then
  begin
    ImagemPGM1 := AbrirImagem(OpenDialogImagem1.FileName);
    LimparImagem(Imagem3);
    DesenharImagem(ImagemPGM1, Imagem1);
  end;
end;

procedure TFormOperacoes.BtAbrirImagem2Click(Sender: TObject);
begin
  if OpenDialogImagem1.Execute
  then
  begin
    ImagemPGM2 := AbrirImagem(OpenDialogImagem1.FileName);
    LimparImagem(Imagem3);
    DesenharImagem(ImagemPGM2, Imagem2);
  end;
end;

procedure TFormOperacoes.BtSomarClick(Sender: TObject);
var
  ImagemPGM3: ImagemPGM;
begin
  // Aplicando o algorítmo da soma
  ImagemPGM3 := SomarImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  ImagemPGM3 := NormalizarImagem(ImagemPGM3);

  // Desenhando a imagem resultante
  DesenharImagem(ImagemPGM3, Imagem3);
end;

procedure TFormOperacoes.BtSubtrairClick(Sender: TObject);
var
  ImagemPGM3: ImagemPGM;
begin
  // Aplicando o algorítmo da subtração
  ImagemPGM3 := SubtrairImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  ImagemPGM3 := NormalizarImagem(ImagemPGM3);

  // Desenhando a imagem resultante
  DesenharImagem(ImagemPGM3, Imagem3);
end;

procedure TFormOperacoes.BtMultiplicarClick(Sender: TObject);
var
  ImagemPGM3: ImagemPGM;
begin
  // Aplicando o algorítmo da multiplicação
  ImagemPGM3 := MultiplicarImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  ImagemPGM3 := NormalizarImagem(ImagemPGM3);

  // Desenhando a imagem resultante
  DesenharImagem(ImagemPGM3, Imagem3);
end;

procedure TFormOperacoes.BtDividirClick(Sender: TObject);
var
  ImagemPGM3: ImagemPGM;
begin
  // Aplicando o algorítmo da divisão
  ImagemPGM3 := DividirImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  ImagemPGM3 := NormalizarImagem(ImagemPGM3);

  // Desenhando a imagem resultante
  DesenharImagem(ImagemPGM3, Imagem3);
end;

procedure TFormOperacoes.BtANDClick(Sender: TObject);
var
  ImagemPGM3: ImagemPGM;
begin
  // Aplicando o algorítmo AND
  ImagemPGM3 := ANDImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  ImagemPGM3 := NormalizarImagem(ImagemPGM3);

  // Desenhando a imagem resultante
  DesenharImagem(ImagemPGM3, Imagem3);
end;

procedure TFormOperacoes.BtORClick(Sender: TObject);
var
  ImagemPGM3: ImagemPGM;
begin
  // Aplicando o algorítmo OR
  ImagemPGM3 := ORImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  ImagemPGM3 := NormalizarImagem(ImagemPGM3);

  // Desenhando a imagem resultante
  DesenharImagem(ImagemPGM3, Imagem3);
end;

procedure TFormOperacoes.BtXORClick(Sender: TObject);
var
  ImagemPGM3: ImagemPGM;
begin
  // Aplicando o algorítmo XOR
  ImagemPGM3 := XORImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  ImagemPGM3 := NormalizarImagem(ImagemPGM3);

  // Desenhando a imagem resultante
  DesenharImagem(ImagemPGM3, Imagem3);
end;

end.
