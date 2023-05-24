using Npgsql;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace newDatabase
{
    public partial class employeePayment : Form
    {
        public employeePayment()
        {
            InitializeComponent();
        }


        NpgsqlConnection connect = new NpgsqlConnection("server=localHost; port=5432; UserId=postgres; password=kedieti7; database=newDatabase");

        private void button5_Click(object sender, EventArgs e)
        {
            //Product List yapacak 
            string query = "select * from product";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            //connect.Close();
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void button9_Click(object sender, EventArgs e)
        {
            connect.Open();

            string query = "select * from searchproduct(:name)";

            NpgsqlCommand cmd = new NpgsqlCommand(query, connect);
            cmd.Parameters.AddWithValue("name", textBox1.Text);

            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];

            connect.Close();

        }

        private void button1_Click(object sender, EventArgs e)
        {
            employeePage form=new employeePage();
            form.Show();
            this.Hide();
        }

        private void button3_Click(object sender, EventArgs e)
        {

                connect.Open();

                string query = "SELECT * FROM add_tax(:payment_type,:price,:quantity)";

                NpgsqlCommand cmd = new NpgsqlCommand(query, connect);
                cmd.Parameters.AddWithValue("payment_type", textBox6.Text);
                cmd.Parameters.AddWithValue("price", int.Parse(textBox3.Text));
                cmd.Parameters.AddWithValue("quantity", int.Parse(textBox2.Text));

                NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                adapt.Fill(ds);
                dataGridView1.DataSource = ds.Tables[0];

              connect.Close();
            
        }


    }
    
}
