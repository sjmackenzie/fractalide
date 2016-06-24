{ stdenv, buildFractalideComponent, filterContracts, genName, upkeepers
  , ...}:

buildFractalideComponent rec {
  name = genName ./.;
  src = ./.;
  filteredContracts = filterContracts [];
  depsSha256 = "0f9h786fnbhxcaw7149r6r4d8zmpjg4vph2b9fbh9wp6kd2l028m";
  
  meta = with stdenv.lib; {
    description = "Component: Drop an Information Packet";
    homepage = https://github.com/fractalide/fractalide/tree/master/components/drop/ip;
    license = with licenses; [ mpl20 ];
    maintainers = with upkeepers; [ dmichiels sjmackenzie];
  };
}