REM GroundFilter [switches] outputfile cellsize datafile1
c:\fusion\GroundFilter E:\Mestrado\Sintegra2019\emerg\result\gf\NP_T-396gnd.las 8 E:\Mestrado\Sintegra2019\emerg\dados\NP_T-396.las

REM GridSurfaceCreate [switches] surfacefile cellsize xyunits zunits coordsys zone horizdatum vertdatum datafile1
c:\fusion\GridSurfaceCreate E:\Mestrado\Sintegra2019\emerg\result\dtm\NP_T-396dtm.dtm 1 m m 1 0 0 0 E:\Mestrado\Sintegra2019\emerg\result\gf\NP_T-396gnd.las

REM CanopyModel [switches] surfacefile cellsize xyunits zunits coordsys zone horizdatum vertdatum datafile1
c:\fusion\CanopyModel /ground:E:\Mestrado\Sintegra2019\emerg\result\dtm\NP_T-396dtm.dtm /ascii E:\Mestrado\Sintegra2019\emerg\result\dtm\NP_T-396chm.dtm 1 m m 1 0 0 0 E:\Mestrado\Sintegra2019\emerg\dados\NP_T-396.las

REM SplitDTM [switches] inputDTM outputDTM columns rows
c:\fusion\SplitDTM E:\Mestrado\Sintegra2019\emerg\result\dtm\NP_T-396chm.dtm E:\Mestrado\Sintegra2019\emerg\result\tiles\NP_T-396chm_tile.dtm 2 2

REM CanopyMaxima [switches] inputfile outputfile
for %%N in (1 2) do (
	call c:\fusion\CanopyMaxima /threshold:30 /wse:20,0,0,0 /shape E:\Mestrado\Sintegra2019\emerg\result\tiles\NP_T-396chm_tile_0001_000%%N.dtm E:\Mestrado\Sintegra2019\emerg\result\csv\NP_T-396tree_tile_0001_000%%N.csv
)

for %%N in (1 2) do (
	call c:\fusion\CanopyMaxima /threshold:30 /wse:20,0,0,0 /shape E:\Mestrado\Sintegra2019\emerg\result\tiles\NP_T-396chm_tile_0002_000%%N.dtm E:\Mestrado\Sintegra2019\emerg\result\csv\NP_T-396tree_tile_0002_000%%N.csv
)


pause