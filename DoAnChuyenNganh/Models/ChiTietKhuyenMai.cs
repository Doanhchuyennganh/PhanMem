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
    
    public partial class ChiTietKhuyenMai
    {
        public int ChiTietKhuyenMaiID { get; set; }
        public Nullable<int> SanPhamID { get; set; }
        public Nullable<int> KhuyenMaiID { get; set; }
        public Nullable<bool> DaHetHan { get; set; }
    
        public virtual KhuyenMai KhuyenMai { get; set; }
        public virtual SanPham SanPham { get; set; }
    }
}