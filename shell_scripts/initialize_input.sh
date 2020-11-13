#!/bin/bash
# Program:
#       This program sets up dcd and pdb of central base-pairs

# Ad hocs
rootfolder=/Users/alayah361/fluctmatch
host=me123
type_na=bdna+bdna

if [ $type_na == "arna+arna" ]; then
    na=arna
elif [ $type_na == "bdna+bdna" ]; then
    na=bdna
fi

gmx=/usr/local/bin/gmx
inputfolder=${rootfolder}/${host}/${type_na}/input/allatoms
inp_xtc=${inputfolder}/${type_na}.all.xtc
inp_pdb=${inputfolder}/${type_na}.npt4.all.pdb

# gro to pdb
out_gro=${inputfolder}/${type_na}.npt4.all.gro
${gmx} editconf -f ${inp_pdb} -o ${out_gro}

# make index
ndx=${inputfolder}/${type_na}.ndx
${gmx} make_ndx -f ${out_gro} -o ${ndx}

# make central pdb
central_pdb=${inputfolder}/${type_na}.central.pdb
${gmx} editconf -f ${out_gro} -o ${central_pdb} -n ${ndx}

# make central xtc
central_xtc=${inputfolder}/${type_na}.central.xtc
${gmx} trjconv -s ${out_gro} -f ${inp_xtc} -o ${central_xtc} -n ${ndx}

# cp central pdb to pdb1 pdb2
pdb1=${inputfolder}/${na}1.central.pdb
pdb2=${inputfolder}/${na}2.central.pdb
cp $central_pdb $pdb1
cp $central_pdb $pdb2
