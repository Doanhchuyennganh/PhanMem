//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DoAnChuyenNganh.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class PhanHoi
    {
        public int PhanHoiID { get; set; }
        public int SanPhamID { get; set; }
        public int NguoiDungID { get; set; }
        public string NoiDung { get; set; }
        public Nullable<int> DanhGia { get; set; }
        public Nullable<System.DateTime> NgayPhanHoi { get; set; }
    
        public virtual NguoiDung NguoiDung { get; set; }
        public virtual SanPham SanPham { get; set; }
    }
}
