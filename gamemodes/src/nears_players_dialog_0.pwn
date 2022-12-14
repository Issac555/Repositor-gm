thIdx(callback:cb, const l[], const r[], dest[], ls = sizeof (l), rs = sizeof (r), ds = sizeof (dest))
{
	CB_GET("iii");
	for (new len = min(ds, min(ls, rs)), i; i != len; ++i)
	{
		dest[i] = CB_CALL(i, l[i], r[i]);
	}
	return CB_REL();
}
#define ZipWithIdx({%0}%1)%8; LAMBDA_ii<ZipWith>{%0}(%1)%8;

stock ZipWithIdx_(callback:cb, const l[], const r[], ls = sizeof (l), rs = sizeof (r))
{
	CB_GET("iii");
	for (new len = min(ls, rs), i; i != len; ++i)
	{
		CB_CALL(i, l[i], r[i]);
	}
	return CB_REL();
}
#define ZipWithIdx_({%0}%1)%8; LAMBDA_ii<ZipWith_>{%0}(%1)%8;

stock ZipWith3Idx(callback:cb, const l[], const m[], const r[], dest[], ls = sizeof (l), ms = sizeof (m), rs = sizeof (r), ds = sizeof (dest))
{
	CB_GET("iiii");
	for (new len = min(min(ms, ds), min(ls, rs)), i; i != len; ++i)
	{
		dest[i] = CB_CALL(i, l[i], m[i], r[i]);
	}
	return CB_REL();
}
#define ZipWith3Idx({%0}%1)%8; LAMBDA_iii<ZipWith3>{%0}(%1)%8;

stock ZipWith3Idx_(callback:cb, const l[], const m[], const r[], ls = sizeof (l), ms = sizeof (m), rs = sizeof (r))
{
	CB_GET("iiii");
	for (new len = min(ms, min(ls, rs)), i; i != len; ++i)
	{
		CB_CALL(i, l[i], m[i], r[i]);
	}
	return CB_REL();
}
#define ZipWith3Idx_({%0}%1)%8; LAMBDA_iii<ZipWith3_>{%0}(%1)%8;

stock FoldLIdx(callback:cb, n, const arr[], len = sizeof (arr))
{
	CB_GET("iii");
	new
		cur = n;
	for (new i = 0; i != len; ++i)
	{
		cur = CB_CALL(i, cur, arr[i]);
	}
	return
		CB_REL(),
		cur;
}
#define FoldLIdx({%0}%1)%8; LAMBDA_ii<FoldL>{%0}(%1)%8;

stock ScanLIdx(callback:cb, n, const arr[], dest[], al = sizeof (arr), dl = sizeof (dest))
{
	if (!dl) return 0;
	CB_GET("iii");
	new
		len = min(al, dl - 1),
		i = -1,
		cur = n;
	while (++i != len)
	{
		dest[i] = cur,
		cur = CB_CALL(i, cur, arr[i]);
	}
	dest[i] = cur;
	return
		CB_REL(),
		1;
}
#define ScanLIdx({%0}%1)%8; LAMBDA_ii<ScanL>{%0}(%1)%8;

stock FoldRIdx(callback:cb, const arr[], n, len = sizeof (arr))
{
	CB_GET("iii");
	new
		cur = n;
	while (len--)
	{
		cur = CB_CALL(i, arr[len], cur);
	}
	return
		CB_REL(),
		cur;
}
#define FoldRIdx({%0}%1)%8; LAMBDA_ii<FoldR>{%0}(%1)%8;

stock ScanRIdx(callback:cb, n, const arr[], dest[], al = sizeof (arr), dl = sizeof (dest))
{
	if (!dl) return 0;
	CB_GET("iii");
	new
		len = min(al, dl - 1),
		cur = n;
	dest[len] = cur;
	while (len--)
	{
		dest[len] = cur = CB_CALL(i, arr[len], cur);
	}
	return
		CB_REL(),
		1;
}
#define ScanRIdx({%0}%1)%8; LAMBDA_ii<ScanR>{%0}(%1)%8;

stock FoldL1Idx(callback:cb, const arr[], len = sizeof (arr))
{
	assert(len > 0);
	CB_GET("iii");
	new
		cur = arr[0];
	for (new i = 1; i != len; ++i)
	{
		cur = CB_CALL(i, cur, arr[i]);
	}
	return
		CB_REL(),
		cur;
}
#define FoldL1Idx({%0}%1)%8; LAMBDA_ii<FoldL1>{%0}(%1)%8;

stock FoldR1Idx(callback:cb, const arr[], len = sizeof (arr))
{
	assert(len > 0);
	CB_GET("iii");
	new
		cur = arr[--len];
	while (len--)
	{
		cur = CB_CALL(i, arr[len], cur);
	}
	return
		CB_REL(),
		cur;
}
#define FoldR1Idx({%0}%1)%8; LAMBDA_ii<FoldR1>{%0}(%1)%8;

stock FoldL(callback:cb, n, const arr[], len = sizeof (arr))
{
	CB_GET("ii");
	new
		cur = n;
	for (new i = 0; i != len; ++i)
	{
		cur = CB_CALL(cur, arr[i]);
	}
	return
		CB_REL(),
		cur;
}
#define FoldL({%0}%1)%8; LAMBDA_ii<FoldL>{%0}(%1)%8;

stock ScanL(callback:cb, n, const arr[], dest[], al = sizeof (arr), dl = sizeof (dest))
{
	if (!dl) return 0;
	CB_GET("ii");
	new
		len = min(al, dl - 1),
		i = -1,
		cur = n;
	while (++i != len)
	{
		dest[i] = cur,
		cur = CB_CALL(cur, arr[i]);
	}
	dest[i] = cur;
	return
		CB_REL(),
		1;
}
#define ScanL({%0}%1)%8; LAMBDA_ii<ScanL>{%0}(%1)%8;

stock FoldR(callback:cb, const arr[], n, len = sizeof (arr))
{
	CB_GET("ii");
	new
		cur = n;
	while (len--)
	{
		cur = CB_CALL(arr[len], cur);
	}
	return
		CB_REL(),
		cur;
}
#define FoldR({%0}%1)%8; LAMBDA_ii<FoldR>{%0}(%1)%8;

stock ScanR(callback:cb, n, const arr[], dest[], al = sizeof (arr), dl = sizeof (dest))
{
	if (!dl) return 0;
	CB_GET("ii");
	new
		len = min(al, dl - 1),
		cur = n;
	dest[len] = cur;
	while (len--)
	{
		dest[len] = cur = CB_CALL(arr[len], cur);
	}
	return
		CB_REL(),
		1;
}
#define ScanR({%0}%1)%8; LAMBDA_ii<ScanR>{%0}(%1)%8;

stock FoldL1(callback:cb, const arr[], len = sizeof (arr))
{
	assert(len > 0);
	CB_GET("ii");
	new
		cur = arr[0];
	for (new i = 1; i != len; ++i)
	{
		cur = CB_CALL(cur, arr[i]);
	}
	return
		CB_REL(),
		cur;
}
#define FoldL1({%0}%1)%8; LAMBDA_ii<FoldL1>{%0}(%1)%8;

stock FoldR1(callback:cb, const arr[], len = sizeof (arr))
{
	assert(len > 0);
	CB_GET("ii");
	new
		cur = arr[--len