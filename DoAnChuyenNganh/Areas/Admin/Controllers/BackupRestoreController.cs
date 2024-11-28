using DoAnChuyenNganh.Filters;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class BackupRestoreController : Controller
    {
        // GET: Admin/BackupRestore
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Index(string backupLocation)
        {
            // Kiểm tra nếu người dùng không nhập đường dẫn hoặc đường dẫn không hợp lệ
            if (string.IsNullOrEmpty(backupLocation) || !Directory.Exists(backupLocation))
            {
                ViewBag.Message = "Đường dẫn thư mục không hợp lệ hoặc không tồn tại.";
                return View();
            }

            // Đảm bảo thư mục backup tồn tại
            string backupFilePath = Path.Combine(backupLocation, "YourDatabase.bak");
            if (!Directory.Exists(Path.GetDirectoryName(backupFilePath)))
            {
                Directory.CreateDirectory(Path.GetDirectoryName(backupFilePath));
            }

            // Chuỗi kết nối tới cơ sở dữ liệu SQL Server
            string connectionString = "Server=DESKTOP-LQ3ORBF;Database=ShopQuanAo;Integrated Security=True;"; // Cập nhật chuỗi kết nối

            // Câu lệnh backup SQL
            string sql = $"BACKUP DATABASE ShopQuanAo TO DISK = @BackupFilePath";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Sử dụng SqlCommand với tham số để tránh lỗi SQL injection
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        command.Parameters.AddWithValue("@BackupFilePath", backupFilePath);

                        // Thực hiện backup
                        command.ExecuteNonQuery();
                        ViewBag.Message = "Backup thành công!";
                    }
                }
                catch (Exception ex)
                {
                    // Xử lý lỗi và hiển thị thông báo
                    ViewBag.Message = "Lỗi: " + ex.Message;
                }
            }

            return View();
        }

        public ActionResult RestoreDatabase()
        {
            return View();
        }
        [HttpPost]
        public ActionResult RestoreDatabase(HttpPostedFileBase restoreFile)
        {
            if (restoreFile == null || restoreFile.ContentLength == 0)
            {
                ViewBag.Message = "Vui lòng chọn file backup để restore.";
                return View();
            }

            // Đường dẫn nơi lưu trữ file backup tạm thời
            string restorePath = Path.Combine(Server.MapPath("~/"), restoreFile.FileName);

            // Lưu file tải lên vào thư mục tạm
            restoreFile.SaveAs(restorePath);

            // Tạo câu lệnh restore SQL
            string connectionString = "Data Source=DESKTOP-LQ3ORBF;Initial Catalog=master;User ID=sa;Password=123;";
            string sql = $"RESTORE DATABASE ShopQuanAo FROM DISK = '{restorePath}'";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sql, connection);
                try
                {
                    command.ExecuteNonQuery();
                    ViewBag.Message = "Restore thành công.";
                }
                catch (Exception ex)
                {
                    ViewBag.Message = "Lỗi: " + ex.Message;
                }
            }

            return View();
        }
    }
}