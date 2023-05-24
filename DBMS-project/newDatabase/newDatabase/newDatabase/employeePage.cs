using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace newDatabase
{
    public partial class employeePage : Form
    {
        public employeePage()
        {
            InitializeComponent();
        }

        private void button7_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            //product işlemleri için sayfaya yönlendirsin


            employeeProduct form=new employeeProduct();
            form.Show();
            this.Hide();


        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            employeePayment form = new employeePayment();
            form.Show();
            this.Hide();

        }

        private void button5_Click(object sender, EventArgs e)
        {
            Form1 form = new Form1();
            form.Show();
            this.Hide();
        }
    }
}
