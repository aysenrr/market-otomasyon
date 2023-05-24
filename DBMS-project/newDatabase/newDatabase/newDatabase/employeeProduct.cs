using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace newDatabase
{
    public partial class employeeProduct : Form
    {
        public employeeProduct()
        {
            InitializeComponent();
        }


        NpgsqlConnection connect = new NpgsqlConnection("server=localHost; port=5432; UserId=postgres; password=kedieti7; database=newDatabase");
        private void button1_Click(object sender, EventArgs e)
        {
            //stock u az olan ürünnleri göstercek

            string query = "select * from low_product";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            //connect.Close();
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void button2_Click(object sender, EventArgs e)
        {
            employeePage form = new employeePage();
            form.Show();
            this.Hide();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            connect.Open();

            string query = "select * from apply_discount()";

            NpgsqlCommand cmd = new NpgsqlCommand(query, connect);
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];

            connect.Close();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            connect.Open();

            string query = "select * from sort_products_by_price()";
            NpgsqlCommand cmd = new NpgsqlCommand(query, connect);
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];

            connect.Close();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            //List işlemleri

            connect.Open();

            string query = "select * from product";
            NpgsqlCommand cmd = new NpgsqlCommand(query, connect);
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];

            connect.Close();


        }
    }
}
