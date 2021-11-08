defmodule ImposterArtist.Games.CodeGenerator do
  # 64 bits of entropy for alhpanumeric slug
  use(Puid, bits: 64, charset: :alphanum)
end
