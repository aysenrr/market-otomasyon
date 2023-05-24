using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace newDatabase
{

    public partial class managerSupplier : Form
    {
        public managerSupplier()
        {
            InitializeComponent();
        }
        NpgsqlConnection connect = new NpgsqlConnection("server=localHost; port=5432; UserId=postgres; password=kedieti7; database=newDatabase");
       

        private void button1_Click(object sender, EventArgs e)
        {

            //Supplier list kısmı
            string query = "select * from supplier";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            connect.Close();
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void button5_Click(object sender, EventArgs e)
        {
            //supplier insert kısmı

            connect.Open();
            NpgsqlCommand command1 = new NpgsqlCommand("insert into supplier values(@supplier_id,@name,@region,@contact_no,@contact_person)", connect);
            command1.Parameters.AddWithValue("@supplier_id", int.Parse(textBox1.Text));
            command1.Parameters.AddWithValue("@name", textBox2.Text);
            command1.Parameters.AddWithValue("@region", textBox3.Text);
            command1.Parameters.AddWithValue("@contact_no", textBox4.Text);
            command1.Parameters.AddWithValue("@contact_person", textBox5.Text);
            command1.ExecuteNonQuery();
            string query = "select * from supplier";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            connect.Close();
            dataGridView1.DataSource = ds.Tables[0];

            connect.Close();
            MessageBox.Show("supplier insert operation has been done succesfully.");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //supplier delete kısmı

            connect.Open();
            NpgsqlCommand command3 = new NpgsqlCommand("Delete from supplier where\"supplier_id\"=@supplierid", connect);
            command3.Parameters.AddWithValue("@supplierid", int.Parse(textBox1.Text));
            command3.ExecuteNonQuery();

            string query = "select * from supplier";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            connect.Close();
            dataGridView1.DataSource = ds.Tables[0];

            MessageBox.Show("Supplier delete operation has been done succesfully", "Bilgi", MessageBoxButtons.YesNo, MessageBoxIcon.Stop);
            connect.Close();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            //supplier update

            connect.Open();
            NpgsqlCommand command3 = new NpgsqlCommand("update supplier set name=@name, region=@region, contact_no=@contact_no, contact_person=@contact_person where supplier_id=@supplierid", connect);
            command3.Parameters.AddWithValue("@supplierid", int.Parse(textBox1.Text));
            command3.Parameters.AddWithValue("@name", textBox2.Text);
            command3.Parameters.AddWithValue("@region", textBox3.Text);
            command3.Parameters.AddWithValue("@contact_no", textBox4.Text);
            command3.Parameters.AddWithValue("@contact_person", textBox5.Text);
            command3.ExecuteNonQuery();
            string query = "select * from supplier";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            connect.Close();
            dataGridView1.DataSource = ds.Tables[0];
            MessageBox.Show("Supplier update operations has been done succesfully", "Bilgi", MessageBoxButtons.YesNo, MessageBoxIcon.Stop);
            connect.Close();
        }

        private void button4_Click(object sender, EventArgs e)
        {

            managerPage form=new managerPage();
            form.Show();
            this.Hide();

        }
    }
}
