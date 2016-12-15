function Citrix-Encode {

	param ($s = "", $k = $null)

	if ($k -eq $null) {
		$k = Get-Random 256
	}

	$p = $k -bxor ($k -bor [int][char]'C')

	$e = ($s.Length + 1).ToString("x4") + $k.ToString("x2")

	$s.ToCharArray() |% {
		$c = $_ -bxor $p -bxor $k
		$e += $c.ToString("x2")
		$p = $c
	}

	return $e
}


function Citrix-Decode {

	param ($s = $null)

	$l = [regex]::split($s, '(?<=\G.{2})')

	$n = [convert]::toint16($l[0]+$l[1],16) + 1
	$k = [convert]::toint16($l[2],16)

	$p = $k -bxor ($k -bor [int][char]'C')
	$d = ""

	$l[3..$n] |% {
		$c = [convert]::toint16($_,16)
		$d += [char]($c -bxor $p -bxor  $k)
		$p = $c
	}

	return $d
}