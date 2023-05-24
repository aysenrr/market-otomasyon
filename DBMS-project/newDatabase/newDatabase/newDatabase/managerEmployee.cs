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
    public partial class managerEmployee : Form
    {
        public managerEmployee()
        {
            InitializeComponent();
        }

        NpgsqlConnection connect = new NpgsqlConnection("server=localHost; port=5432; UserId=postgres; password=kedieti7; database=newDatabase");
        private void button1_Click(object sender, EventArgs e)
        {
            //List employee


            string query = "select * from employee";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            //connect.Close();
            dataGridView1.DataSource = ds.Tables[0];


        }

        private void button2_Click(object sender, EventArgs e)
        {
            //employee insert

            connect.Open();
            NpgsqlCommand command1 = new NpgsqlCommand("insert into employee values(@employee_id,@name,@surname,@age,@gender,@contact_no,@company_id,@store_id,@department_id,@salary)", connect);
            command1.Parameters.AddWithValue("@employee_id", int.Parse(textBox1.Text));
            command1.Parameters.AddWithValue("@name", textBox2.Text);
            command1.Parameters.AddWithValue("@surname", textBox3.Text);
            command1.Parameters.AddWithValue("@age", int.Parse(textBox4.Text));
            command1.Parameters.AddWithValue("@gender", textBox5.Text);
            command1.Parameters.AddWithValue("@contact_no", textBox6.Text);
            command1.Parameters.AddWithValue("@company_id", int.Parse(textBox7.Text));
            command1.Parameters.AddWithValue("@store_id", int.Parse(textBox8.Text));
            command1.Parameters.AddWithValue("@department_id", int.Parse(textBox9.Text));
            command1.Parameters.AddWithValue("@salary", int.Parse(textBox10.Text));

            command1.ExecuteNonQuery();
            MessageBox.Show("Employee insert operation has been done succesfully.");

            string query = "select * from employee";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            //connect.Close();
            dataGridView1.DataSource = ds.Tables[0];




            connect.Close();
           
            //ulan hayaaaaat  

        }

        private void button3_Click(object sender, EventArgs e)
        {
            //employee delete

            connect.Open();
            NpgsqlCommand command3 = new NpgsqlCommand("Delete from employee where\"employee_id\"=@employee_id", connect);
            command3.Parameters.AddWithValue("@employee_id", int.Parse(textBox1.Text));
            command3.ExecuteNonQuery();
            MessageBox.Show("Employee delete operation has been done succesfully", "Bilgi", MessageBoxButtons.YesNo, MessageBoxIcon.Stop);

            string query = "select * from employee";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            //connect.Close();
            dataGridView1.DataSource = ds.Tables[0];
            connect.Close();


        }

        private void button4_Click(object sender, EventArgs e)
        {
            //employee update

            connect.Open();
            NpgsqlCommand command3 = new NpgsqlCommand("update employee set employee_id=@employee_id,name=@name, surname=@surname, age=@age , gender=@gender, contact_no=@contact_no, company_id=@company_id, store_id=@store_id, department_id=@department_id where employee_id=@employee_id", connect);
            command3.Parameters.AddWithValue("@employee_id", int.Parse(textBox1.Text));
            command3.Parameters.AddWithValue("@name", textBox2.Text);
            command3.Parameters.AddWithValue("@surname", textBox3.Text);
            command3.Parameters.AddWithValue("@age", int.Parse(textBox4.Text));
            command3.Parameters.AddWithValue("@gender", textBox5.Text);
            command3.Parameters.AddWithValue("@contact_no", textBox6.Text);
            command3.Parameters.AddWithValue("@company_id", int.Parse(textBox7.Text));
            command3.Parameters.AddWithValue("@store_id", int.Parse(textBox8.Text));
            command3.Parameters.AddWithValue("@department_id", int.Parse(textBox9.Text));
            command3.ExecuteNonQuery();
            MessageBox.Show("Employee update operations has been done succesfully", "Bilgi", MessageBoxButtons.YesNo, MessageBoxIcon.Stop);

            string query = "select * from employee";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            //connect.Close();
            dataGridView1.DataSource = ds.Tables[0];


            connect.Close();

        }


        private void textBox5_TextChanged(object sender, EventArgs e)
        {

        }
        private void label8_Click(object sender, EventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {
            managerPage form = new managerPage();
            form.Show();
            this.Hide();

        }
    }
}
