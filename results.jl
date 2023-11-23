### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ c55295bf-1c27-463a-9c04-b9a325bbcc47
using CSV, DataFrames, GLM, LaTeXStrings, PlutoPlotly, PlutoUI, Statistics

# ╔═╡ de15fcdb-6df2-47a7-86b5-81f185ff810e
begin
obj2 = CSV.read("df5.csv", DataFrame);
obj0 = filter(x -> x.POLLUTANT == 0.0, obj2);
obj1 = obj2[obj2.ADAP_VELOCITY .== 0.0, :];
nothing
end

# ╔═╡ 5618c0f0-2f26-4720-933d-814056b0a66d
begin
pol=["0", "10<sup>2</sup>", "10<sup>4</sup>", "10<sup>5</sup>", "10<sup>5.125</sup>", "10<sup>5.25</sup>", "10<sup>5.375</sup>", "10<sup>5.5</sup>", "10<sup>5.625</sup>", "10<sup>5.75</sup>", "10<sup>5.875</sup>", "10<sup>6</sup>", "10<sup>8</sup>", "10<sup>10</sup>"];

	adap=["0.0", "10<sup>-5.6</sup>", "10<sup>-4.8</sup>", "10<sup>-4.4</sup>", "10<sup>-4.2</sup>", "10<sup>-4.0</sup>", "10<sup>-3.2</sup>", "10<sup>-2.4</sup>", "10<sup>-1.6</sup>", "10<sup>-0.8</sup>", "1.0"];
	nothing
end;

# ╔═╡ 067d2daa-6fde-49c8-8bb4-be3071dc346f
html"""
<h2>Picking treatments</h2>
<h3>Summary</h3>
"""

# ╔═╡ ba40701e-a3b2-40b9-9d66-a19931397d31
begin
sort!(obj0, [:ADAP_VELOCITY])
gdf0=groupby(obj0, :ADAP_VELOCITY);
obj0_stats = combine(gdf0, nrow, :PERSISTENCE => mean, :PERSISTENCE => std, :DIV_H => mean, :DIV_H => std);
obj0_stats.PERSISTENCE_sterror = obj0_stats.PERSISTENCE_std ./ sqrt.(obj0_stats.nrow);
obj0_stats.DIV_H_sterror = obj0_stats.DIV_H_std ./ sqrt.(obj0_stats.nrow);
obj0_stats
end

# ╔═╡ 172804d1-38e7-43e1-91da-8548cbef4b6e
html"""
<h3>Species Persistence</h3>
"""

# ╔═╡ 753e34e9-7599-491e-a5b0-5603fdd3fd65
plot(obj0_stats, x=string.(:ADAP_VELOCITY), y=:PERSISTENCE_mean, error_y=attr(type="data", array=:PERSISTENCE_sterror), 
        Layout(
            xaxis_title="Adaptation Velocity", 
            yaxis_title="Species Persistence",
            xaxis_tickvals=0:length(adap)-1,
            xaxis_ticktext=adap
            )
        )

# ╔═╡ 982be3a7-7744-4716-a036-37c6849bc6e3
html"""
<h5>Linear Model</h5>
"""

# ╔═╡ e26cc416-e323-4747-9776-7fb7096e59e7
mdl0_persistence = lm(@formula(PERSISTENCE ~ ADAP_VELOCITY), obj0)

# ╔═╡ b7f20a0f-8709-4cfa-97cb-f61ac84e0d45
html"""
<h3>Shannon Index</h3>
"""

# ╔═╡ ded2708c-4f02-4376-a8f3-623844143db3
plot(obj0_stats, x=string.(:ADAP_VELOCITY), y=:DIV_H_mean, error_y=attr(type="data", array=:DIV_H_sterror), 
        Layout(
            xaxis_title="Adaptation Velocity", 
            yaxis_title="ΔH",
            xaxis_tickvals=0:length(adap)-1,
            xaxis_ticktext=adap
            )
        )

# ╔═╡ 289cd6ef-84a2-4d33-b99b-117a47737802
html"""
<h5>Linear Model</h5>
"""

# ╔═╡ 7b01e775-09f7-4975-98cf-a3677fe0132a
mdl0_shannon = lm(@formula(DIV_H ~ ADAP_VELOCITY), obj0)

# ╔═╡ 7ba4e106-5c60-11ee-14f4-bf04065d02ba
html"""
<h2>OBJECTIVE 1</h2>
<ul>
<li>Species richness = 50</li>
<li>Connectance = 0.2</li>
<li>Pollutant Concentration ∈ [0 10<sup>2</sup> 10<sup>4</sup> 10<sup>5</sup> 10<sup>5.125</sup> 10<sup>5.25</sup> 10<sup>5.375</sup> 10<sup>5.5</sup> 10<sup>5.625</sup> 10<sup>5.75</sup> 10<sup>5.875</sup> 10<sup>6</sup> 10<sup>8</sup> 10<sup>10</sup>]</li>
<li>No adaptation</li>
</ul>
"""

# ╔═╡ 199df2ab-815f-4e12-88f7-662608ad3ca8
html"""
<h3>Summary</h3>
"""

# ╔═╡ 23a951c8-dccd-487d-883c-05c0dbcf6b01
begin
sort!(obj1,[:POLLUTANT])
gdf=groupby(obj1, :POLLUTANT);
obj1_stats = combine(gdf, nrow, :PERSISTENCE => mean, :PERSISTENCE => std, :DIV_H => mean, :DIV_H => std);
obj1_stats.PERSISTENCE_sterror = obj1_stats.PERSISTENCE_std ./ sqrt.(obj1_stats.nrow);
obj1_stats.DIV_H_sterror = obj1_stats.DIV_H_std ./ sqrt.(obj1_stats.nrow);
obj1_stats
end

# ╔═╡ 0333437b-e535-452c-96e3-af37f92ab965
html"""
<h3>Species persistence</h3>
"""

# ╔═╡ e8d90c99-594d-4455-a7b3-50e6c224371f
#p=plot(polLevels[:],stats_obj1.mean_PERSISTENCE,error_y=attr(type="data", array=stats_obj1.err_PERSISTENCE, visible=true), legend=false, xlabel="Pollutant Concentration", ylabel="Species Persistence")
plot(obj1_stats, x=string.(:POLLUTANT), y=:PERSISTENCE_mean, error_y=attr(type="data", array=:PERSISTENCE_sterror), 
        Layout(
            xaxis_title="Pollutant Concentration", 
            yaxis_title="Species Persistence",
            xaxis_tickvals=0:length(pol)-1,
            xaxis_ticktext=pol
            )
        )


# ╔═╡ 9a3e9f17-0398-45a2-9c8f-0eac5bd061e0
html"""
<h5>Linear Model</h5>
"""

# ╔═╡ dea9c011-0ddd-43a6-8007-40629d2988f5
mdl1_persistence = lm(@formula(PERSISTENCE ~ POLLUTANT), obj1)

# ╔═╡ f5c13238-493b-455c-a4b8-eef2f1b913ea
html"""
<h3>Shannon Index</h3>
"""

# ╔═╡ b201f534-325f-44cf-aaee-37bf34175aef
plot(obj1_stats, x=string.(:POLLUTANT), y=:DIV_H_mean, error_y=attr(type="data", array=:DIV_H_sterror), 
        Layout(
            xaxis_title="Pollutant Concentration", 
            yaxis_title="ΔH",
            xaxis_tickvals=0:length(pol)-1,
            xaxis_ticktext=pol
            )
        )

# ╔═╡ dbde5df2-0168-4877-86ff-bf7dddb1007e
html"""
<h5>Linear Model</h5>
"""

# ╔═╡ aff13a12-25b0-44fc-aa79-81e8eb5bc2ce
mdl1_shannon = lm(@formula(DIV_H ~ POLLUTANT), obj1)

# ╔═╡ a3f51fbd-5d4e-431f-b5b6-5483a17c41b3
html"""
<h2>OBJECTIVE 2</h2>
<ul>
<li>Species richness = 50</li>
<li>Connectance = 0.2</li>
<li>Pollutant Concentration ∈ [0 10<sup>2</sup> 10<sup>4</sup> 10<sup>5</sup> 10<sup>5.125</sup> 10<sup>5.25</sup> 10<sup>5.375</sup> 10<sup>5.5</sup> 10<sup>5.625</sup> 10<sup>5.75</sup> 10<sup>5.875</sup> 10<sup>6</sup> 10<sup>8</sup> 10<sup>10</sup>]</li>
<li>Adaptation Velocity ∈ [0.0 10<sup>-5.6</sup> 10<sup>-4.8</sup> 10<sup>-4.4</sup> 10<sup>-4.2</sup> 10<sup>-4.0</sup> 10<sup>-3.2</sup> 10<sup>-2.4</sup> 10<sup>-1.6</sup> 10<sup>-0.8</sup> 1.0]</li>
"""

# ╔═╡ 7dabb483-258f-4c3b-8120-bc8dcf7977db
html"""
<h3>Summary</h3>
"""

# ╔═╡ 54b7ed7e-417a-4c1d-a47d-56e0beff2d80
begin
sort!(obj2, [:POLLUTANT, :ADAP_VELOCITY])
gdf2=groupby(obj2, [:POLLUTANT, :ADAP_VELOCITY]);
obj2_stats = combine(gdf2, nrow, :PERSISTENCE => mean, :PERSISTENCE => std, :DIV_H => mean, :DIV_H => std);
obj2_stats.PERSISTENCE_sterror = obj2_stats.PERSISTENCE_std ./ sqrt.(obj2_stats.nrow);
obj2_stats.DIV_H_sterror = obj2_stats.DIV_H_std ./ sqrt.(obj2_stats.nrow);
obj2_stats
end

# ╔═╡ f7a7e0b9-b791-469d-9d0a-d26103416a7d
html"""
<h3>Species persistence</h3>
"""

# ╔═╡ e32728af-2a67-45e0-8e25-417d108b4caa
begin
	data = AbstractTrace[];
	
	i = 1;
	for a in unique(obj2.ADAP_VELOCITY)
		push!(data, scatter(filter(x -> x.ADAP_VELOCITY == a, obj2_stats), x=string.(:POLLUTANT), y=:PERSISTENCE_mean, error_y=attr(type="data", array=:PERSISTENCE_sterror), name=adap[i]))
		i += 1;
	end

	layout = Layout(
            xaxis_title="Pollutant Concentration", 
            yaxis_title="Species Persistence",
            xaxis_tickvals=0:length(pol)-1,
            xaxis_ticktext=pol
            ); 
	p1_obj2 = plot(data, layout);
	p1_obj2
end

# ╔═╡ 4741e345-3308-4089-a124-5f7e4fa4a0b2
html"""
<h5>GLM</h5>
<p>Normal Distribution</p>
"""

# ╔═╡ c880580a-418b-4ee5-8307-4aefd9e07077
mdl2_persistence = glm(@formula(PERSISTENCE ~ POLLUTANT * ADAP_VELOCITY), obj2, Normal(), dropcollinear=false)

# ╔═╡ 3a502564-029e-4fdb-a687-68c0c8487124
html"""
<h3>Shannon Index</h3>
"""

# ╔═╡ 2c4b4538-614a-4f28-b53a-0ab47eab1589
begin
	data2 = AbstractTrace[];
	
	j = 1;
	for a in unique(obj2.ADAP_VELOCITY)
		push!(data2, scatter(filter(x -> x.ADAP_VELOCITY == a, obj2_stats), x=string.(:POLLUTANT), y=:DIV_H_mean, error_y=attr(type="data", array=:DIV_H_sterror), name=adap[j]))
		j += 1;
	end

	layout2 = Layout(
            xaxis_title="Pollutant Concentration", 
            yaxis_title="ΔH",
            xaxis_tickvals=0:length(pol)-1,
            xaxis_ticktext=pol
            ); 
	p2_obj2 = plot(data2, layout2);
	p2_obj2
end

# ╔═╡ 7a642279-9540-4763-8f45-8eaf8a17a6b1
html"""
<h5>GLM</h5>
<p>Normal Distribution</p>
"""

# ╔═╡ c9c3cb2d-ccfe-4d9a-b5a0-dec93164585c
mdl2_shannon = glm(@formula(DIV_H ~ POLLUTANT * ADAP_VELOCITY), obj2, Normal(), dropcollinear=false)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
GLM = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
CSV = "~0.10.11"
DataFrames = "~1.6.1"
GLM = "~1.9.0"
LaTeXStrings = "~1.3.0"
PlutoPlotly = "~0.3.9"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "b3b25d0226058a31c0ab897504cedce673585074"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "3d5873f811f582873bb9871fc9c451784d5dc8c7"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.102"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "a20eaa3ad64254c61eeb5f230d9306e937405434"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.6.1"
weakdeps = ["SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLM]]
deps = ["Distributions", "LinearAlgebra", "Printf", "Reexport", "SparseArrays", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "StatsModels"]
git-tree-sha1 = "273bd1cd30768a2fddfa3fd63bbc746ed7249e5f"
uuid = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
version = "1.9.0"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "b7c4f29f93b548caa58f703580f4d79ab753c8ac"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.21"

[[deps.PackageExtensionCompat]]
git-tree-sha1 = "fb28e33b8a95c4cee25ce296c817d89cc2e53518"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.2"
weakdeps = ["Requires", "TOML"]

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "Colors", "Dates", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "PackageExtensionCompat", "PlotlyBase", "PlutoUI", "Reexport"]
git-tree-sha1 = "9a77654cdb96e8c8a0f1e56a053235a739d453fe"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.3.9"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "ee094908d720185ddbdc58dbe0c1cbe35453ec7a"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.7"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "04bdff0b09c65ff3e06a05e3eb7b120223da3d39"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.ShiftedArrays]]
git-tree-sha1 = "503688b59397b3307443af35cd953a13e8005c16"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "2.0.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StatsModels]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Printf", "REPL", "ShiftedArrays", "SparseArrays", "StatsAPI", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "5cf6c4583533ee38639f73b880f35fc85f2941e0"
uuid = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
version = "0.7.3"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "a1f34829d5ac0ef499f6d84428bd6b4c71f02ead"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═c55295bf-1c27-463a-9c04-b9a325bbcc47
# ╠═de15fcdb-6df2-47a7-86b5-81f185ff810e
# ╠═5618c0f0-2f26-4720-933d-814056b0a66d
# ╟─067d2daa-6fde-49c8-8bb4-be3071dc346f
# ╠═ba40701e-a3b2-40b9-9d66-a19931397d31
# ╟─172804d1-38e7-43e1-91da-8548cbef4b6e
# ╠═753e34e9-7599-491e-a5b0-5603fdd3fd65
# ╟─982be3a7-7744-4716-a036-37c6849bc6e3
# ╠═e26cc416-e323-4747-9776-7fb7096e59e7
# ╟─b7f20a0f-8709-4cfa-97cb-f61ac84e0d45
# ╠═ded2708c-4f02-4376-a8f3-623844143db3
# ╟─289cd6ef-84a2-4d33-b99b-117a47737802
# ╠═7b01e775-09f7-4975-98cf-a3677fe0132a
# ╟─7ba4e106-5c60-11ee-14f4-bf04065d02ba
# ╟─199df2ab-815f-4e12-88f7-662608ad3ca8
# ╠═23a951c8-dccd-487d-883c-05c0dbcf6b01
# ╟─0333437b-e535-452c-96e3-af37f92ab965
# ╠═e8d90c99-594d-4455-a7b3-50e6c224371f
# ╟─9a3e9f17-0398-45a2-9c8f-0eac5bd061e0
# ╠═dea9c011-0ddd-43a6-8007-40629d2988f5
# ╟─f5c13238-493b-455c-a4b8-eef2f1b913ea
# ╠═b201f534-325f-44cf-aaee-37bf34175aef
# ╟─dbde5df2-0168-4877-86ff-bf7dddb1007e
# ╠═aff13a12-25b0-44fc-aa79-81e8eb5bc2ce
# ╟─a3f51fbd-5d4e-431f-b5b6-5483a17c41b3
# ╟─7dabb483-258f-4c3b-8120-bc8dcf7977db
# ╠═54b7ed7e-417a-4c1d-a47d-56e0beff2d80
# ╟─f7a7e0b9-b791-469d-9d0a-d26103416a7d
# ╠═e32728af-2a67-45e0-8e25-417d108b4caa
# ╟─4741e345-3308-4089-a124-5f7e4fa4a0b2
# ╠═c880580a-418b-4ee5-8307-4aefd9e07077
# ╟─3a502564-029e-4fdb-a687-68c0c8487124
# ╠═2c4b4538-614a-4f28-b53a-0ab47eab1589
# ╟─7a642279-9540-4763-8f45-8eaf8a17a6b1
# ╠═c9c3cb2d-ccfe-4d9a-b5a0-dec93164585c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
