/*
Legal:
	Version: MPL 1.1
	
	The contents of this file are subject to the Mozilla Public License Version 
	1.1 the "License"; you may not use this file except in compliance with 
	the License. You may obtain a copy of the License at 
	http://www.mozilla.org/MPL/
	
	Software distributed under the License is distributed on an "AS IS" basis,
	WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
	for the specific language governing rights and limitations under the
	License.
	
	The Original Code is the YSI framework.
	
	The Initial Developer of the Original Code is Alex "Y_Less" Cole.
	Portions created by the Initial Developer are Copyright C 2011
	the Initial Developer. All Rights Reserved.

Contributors:
	Y_Less
	koolk
	JoeBullet/Google63
	g_aSlice/Slice
	Misiur
	samphunter
	tianmeta
	maddinat0r
	spacemud
	Crayder
	Dayvison
	Ahmad45123
	Zeex
	irinel1996
	Yiin-
	Chaprnks
	Konstantinos
	Masterchen09
	Southclaws
	PatchwerkQWER
	m0k1
	paulommu
	udan111

Thanks:
	JoeBullet/Google63 - Handy arbitrary ASM jump code using SCTRL.
	ZeeX - Very productive conversations.
	koolk - IsPlayerinAreaEx code.
	TheAlpha - Danish translation.
	breadfish - German translation.
	Fireburn - Dutch translation.
	yom - French translation.
	50p - Polish translation.
	Zamaroht - Spanish translation.
	Los - Portuguese translation.
	Dracoblue, sintax, mabako, Xtreme, other coders - Producing other modes for
		me to strive to better.
	Pixels^ - Running XScripters where the idea was born.
	Matite - Pestering me to release it and using it.

Very special thanks to:
	Thiadmer - PAWN, whose limits continue to amaze me!
	Kye/Kalcor - SA:MP.
	SA:MP Team past, present and future - SA:MP.

Optional plugins:
	Gamer_Z - GPS.
	Incognito - Streamer.
	Me - sscanf2, fixes2, Whirlpool.
*/

static stock
	YSI_g_sFileHeader[] =
	{
		'B', 'M',   // bfType      (Just "BM" for Windows BMP).
		1, 1, 1, 1, // bfSize      (File size in bytes).
		0, 0,       // bfReserved1 (Unused).
		0, 0,       // bfReserved2 (Unused).
		2, 2, 2, 2  // bfOffBits   (Offset to the start of the data).
	},
	YSI_g_sInfoHeader[] =
	{
		40, 0, 0, 0,  // biSize          (This header's size).
		4,  4, 4, 4,  // biWidth         (Image width).
		5,  5, 5, 5,  // biHeight        (Image height).
		1,  0,        // biPlanes        (1 "plane").
		24, 0,        // biBitCount      (24-bit image).
		0,  0, 0, 0,  // biCompression   (Unused).
		0,  0, 0, 0,  // biSizeImage     (Unused).
		0,  0, 0, 0,  // biXPelsPerMeter (Unused).
		0,  0, 0, 0,  // biYPelsPerMeter (Unused).
		0,  0, 0, 0,  // biClrUsed       (Unused).
		0,  0, 0, 0   // biClrImportant  (Unused).
	};

static stock MKLE32(dest[], num, &idx = 0)
{
	dest[idx++] = num & 0xFF;
	dest[idx++] = num >>> 8 & 0xFF;
	dest[idx++] = num >>> 16 & 0xFF;
	dest[idx++] = num >>> 24 & 0xFF;
}

static stock MK24(dest[], num, &idx = 0)
{
	//if (num != -1) printf("colour %d", num);
	dest[idx++] = num >>>  8 & 0xFF;
	dest[idx++] = num >>> 16 & 0xFF;
	dest[idx++] = num >>> 24 & 0xFF;
}

static stock Bitmap_PadRow(dest[], &idx)
{
	while (idx & 0x03)
	{
		dest[idx++] = 0;
	}
}

static stock Bitmap_WriteHeader(Bitmap:ctx, File:bmp)
{
	MKLE32(YSI_g_sInfoHeader[4], Bitmap_Width(ctx));
	MKLE32(YSI_g_sInfoHeader[8], Bitmap_Height(ctx));
	// Pad to a 4 byte boundary with 3 bytes per pixel.
	MKLE32(YSI_g_sFileHeader[2], ceildiv(Bitmap_Width(ctx) * 3, 4) * 4 * Bitmap_Height(ctx) + sizeof (YSI_g_sFileHeader) + sizeof (YSI_g_sInfoHeader));
	MKLE32(YSI_g_sFileHeader[10], sizeof (YSI_g_sFileHeader) + sizeof (YSI_g_sInfoHeader));
	for (new j = 0; j != sizeof (YSI_g_sFileHeader); ++j)
	{
		fputchar(bmp, YSI_g_sFileHeader[j], false);
	}
	for (new j = 0; j != sizeof (YSI_g_sInfoHeader); ++j)
	{
		fputchar(bmp, YSI_g_sInfoHeader[j], false);
	}
}

static stock Bitmap_WriteBlock(File:bmp, const buf[], len)
{
	for (new i = 0; i != len; ++i)
	{
		fputchar(bmp, buf[i], false);
	}
}

static stock Bitmap_WriteBody(Bitmap:ctx, File:bmp)
{
	// Write 4 pixels in to 3 blocks.
	static
		sWriteBlock[12];
	new
		width = Bitmap_Width(ctx),
		w2 = width & ~0x3,
		height = Bitmap_Height(ctx);
	//width &= 0x3;
	//for (new y = height; y-- > 0; )
	for (new y = height; y-- != 0; )
	{
		// Go through the array backwards (bottom to top).
		new
			x = 0;
		//printf(": %d = %d", Bitmap_IndexCtx(ctx, 10, y), Bitmap_ReadCtx(ctx, 10, y));
		//printf(": %d = %d", Bitmap_IndexInt(ctx, 10, y), Bitmap_ReadInt(ctx, 10, y));
		for ( ; x != w2; x += 4)
		{
			new
				i = 0;
			MK24(sWriteBlock, Bitmap_ReadInt(ctx, x, width, y), i);
			MK24(sWriteBlock, Bitmap_ReadInt(ctx, x + 1, width, y), i);
			MK24(sWriteBlock, Bitmap_ReadInt(ctx, x + 2, width, y), i);
			MK24(sWriteBlock, Bitmap_ReadInt(ctx, x + 3, width, y), i);
			Bitmap_WriteBlock(bmp, sWriteBlock, 12);
	